import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/models/notification_model.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/network/local/cache_helper.dart';
import 'package:ripple/core/network/notification_repository.dart';
import 'package:ripple/core/network/post_repository.dart';
import 'package:ripple/core/network/service/notification_service.dart';
import 'package:ripple/core/network/user_repository.dart';
import 'package:ripple/core/theme/emoji_controller.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/main.dart';
import 'package:image_picker/image_picker.dart';

HomeCubit get homeCubit => HomeCubit.get(navigatorKey.currentContext!);

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  final PostRepository postRepo = PostRepository();
  final NotificationRepository notificationRepo = NotificationRepository();
  final UserRepository userRepo = UserRepository();

  StreamSubscription? _userSubscription;
  StreamSubscription? _postsSubscription;
  StreamSubscription? _userPostsSubscription;
  StreamSubscription? _notificationsSubscription;
  UserModel? userModel;
  UserModel? viewedUserModel;

  // Controllers & Assets
  final EmojiTextEditingController postTextController =
      EmojiTextEditingController();
  final EmojiTextEditingController commentController =
      EmojiTextEditingController();
  final EmojiTextEditingController editPostController =
      EmojiTextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  List<PostModel> posts = [];
  List<PostModel> userPosts = [];
  List<NotificationModel> notifications = [];

  File? postImage;
  File? profileImage;
  File? coverImage;
  File? editPostImage;

  String? editPostImageUrl;
  int unreadNotificationsCount = 0;
  bool isEmojiVisible = false;

  // --- Auth & User Data ---

  void listenToUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _userSubscription?.cancel();
    _userSubscription = userRepo.getUserStream(uid).listen(
      (user) async {
        if (user == null) return;

        userModel = user;
        await _cacheUser(user);
        emit(HomeGetCurrentUserSuccessState());
      },
      onError: (dynamic error) =>
          emit(HomeGetCurrentUserErrorState(error.toString())),
    );
  }

  Future<void> getUserData() async {
    final cached = _getCachedUser();
    if (cached != null) {
      userModel = cached;
      emit(HomeGetCurrentUserSuccessState());
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final fresh = await userRepo.getUser(uid);
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null && fresh?.fcmToken != token) {
        final updatedUser = fresh!.copyWith(fcmToken: token);
        await userRepo.updateUser(updatedUser);
        userModel = updatedUser;
      } else {
        userModel = fresh;
      }

      await _cacheUser(userModel);
      emit(HomeGetCurrentUserSuccessState());
    } catch (e) {
      if (cached == null) emit(HomeGetCurrentUserErrorState(e.toString()));
    }
  }

  Future<void> _cacheUser(UserModel? model) async {
    if (model == null) return;
    final json = jsonEncode(model.toMap());
    await CacheHelper.saveData(key: 'userModel', value: json);
  }

  UserModel? _getCachedUser() {
    final json = CacheHelper.getData(key: 'userModel');
    if (json == null) return null;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return UserModel.fromMap(jsonDecode(json), uid);
  }

  void logout() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    _userPostsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    FirebaseAuth.instance.signOut().then((_) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.pushReplacement<Object>(Routes.login);
      }
    });
  }

  // --- Feed & Posts ---

  void getPosts() {
    emit(HomeGetFeedPostsLoadingState());
    _postsSubscription?.cancel();
    _postsSubscription = postRepo.getPosts().listen(
      (postsList) {
        posts = postsList;
        emit(HomeGetFeedPostsSuccessState(postsList));
      },
      onError: (dynamic e) => emit(HomeGetFeedPostsErrorState(e.toString())),
    );
  }

  Stream<PostModel> getPostStream(String postId) =>
      postRepo.getPostStream(postId);

  Future<void> addPost(String text) async {
    if (userModel == null) return;

    final postText = text.trim();
    final imageToUpload = postImage;

    // UI Reset
    postTextController.clear();
    postImage = null;
    isEmojiVisible = false;

    emit(HomeAddPostLoadingState());
    try {
      String? imageUrl;
      if (imageToUpload != null) {
        imageUrl = await uploadImageToCloudinary(imageToUpload);
      }

      await postRepo.addPost(
        userId: userModel!.uid!,
        username: userModel!.username!,
        userProfilePic: userModel!.photoUrl!,
        text: postText.isNotEmpty ? postText : null,
        imageUrl: imageUrl,
      );
      emit(HomeAddPostSuccessState());
    } catch (e) {
      emit(HomeAddPostErrorState(e.toString()));
    }
  }

  Future<void> togglePostLike(PostModel post) async {
    if (userModel == null) return;
    final isLiked = post.likes.contains(userModel!.uid);

    try {
      await postRepo.toggleLike(
        postId: post.postId,
        currentUserId: userModel!.uid!,
        likes: post.likes,
      );

      if (!isLiked && post.userId != userModel!.uid) {
        await _sendNotification(
          receiverId: post.userId,
          type: 'like',
          postId: post.postId,
          arMsg: "أعجب بمنشورك ❤️",
          enMsg: "liked your post ❤️",
        );
      }
      emit(HomeLikePostSuccessState());
    } catch (e) {
      emit(HomeLikePostErrorState(e.toString()));
    }
  }

  // --- Comments & Replies ---

  Future<void> addComment(String postId, String postOwnerId) async {
    if (userModel == null) return;

    final text = commentController.text.trim();
    if (text.isEmpty) return;

    commentController.clear();
    emit(HomeAddCommentLoadingState());

    try {
      await postRepo.addComment(
        postId: postId,
        userId: userModel!.uid!,
        username: userModel!.username!,
        userProfilePic: userModel!.photoUrl!,
        text: text,
      );

      if (postOwnerId != userModel!.uid) {
        await _sendNotification(
          receiverId: postOwnerId,
          type: 'comment',
          postId: postId,
          arMsg: "علّق على منشورك 💬",
          enMsg: "commented on your post 💬",
          content: text,
        );
      }
      emit(HomeAddCommentSuccessState());
    } catch (e) {
      emit(HomeAddCommentErrorState(e.toString()));
    }
  }

  Future<void> addReply({
    required String postId,
    required String commentId,
    required String commentOwnerId,
    required String text,
  }) async {
    if (userModel == null) return;
    emit(HomeAddCommentLoadingState());
    try {
      await postRepo.addReply(
        postId: postId,
        commentId: commentId,
        userId: userModel!.uid!,
        username: userModel!.username!,
        userProfilePic: userModel!.photoUrl!,
        text: text,
      );

      if (commentOwnerId != userModel!.uid) {
        await _sendNotification(
          receiverId: commentOwnerId,
          type: 'comment',
          postId: postId,
          arMsg: "رد على تعليقك 💬",
          enMsg: "replied to your comment 💬",
          content: text,
        );
      }
      emit(HomeAddCommentSuccessState());
    } catch (e) {
      emit(HomeAddCommentErrorState(e.toString()));
    }
  }

  Future<void> deleteComment(String postId, CommentModel comment) async {
    emit(HomeDeleteCommentLoadingState());
    try {
      await postRepo.deleteComment(postId: postId, comment: comment);
      emit(HomeDeleteCommentSuccessState());
    } catch (e) {
      emit(HomeDeleteCommentErrorState(e.toString()));
    }
  }

  // --- Profile Logic ---

  void initProfile(String? userId) {
    if (userId != null && userId != viewedUserModel?.uid) {
      viewedUserModel = null;
      userPosts = [];
      emit(HomeGetViewedUserLoadingState());
    }

    if (userId == null || userId == userModel?.uid) {
      viewedUserModel = userModel;
      getMyPosts();
    } else {
      getOtherUserData(userId);
      getUserPosts(userId);
    }
  }

  Future<void> getOtherUserData(String userId) async {
    emit(HomeGetViewedUserLoadingState());
    try {
      viewedUserModel = await userRepo.getUser(userId);
      emit(HomeGetViewedUserSuccessState());
    } catch (e) {
      emit(HomeGetViewedUserErrorState(e.toString()));
    }
  }

  void getMyPosts() {
    if (userModel?.uid == null || state is HomeGetProfilePostsLoadingState) {
      return;
    }
    emit(HomeGetProfilePostsLoadingState());
    _userPostsSubscription?.cancel();
    _userPostsSubscription = postRepo.getUserPosts(userModel!.uid!).listen(
      (postsList) {
        userPosts = postsList;
        emit(HomeGetProfilePostsSuccessState(postsList));
      },
      onError: (dynamic e) => emit(HomeGetProfilePostsErrorState(e.toString())),
    );
  }

  void getUserPosts(String userId) {
    if (state is HomeGetProfilePostsLoadingState) return;
    emit(HomeGetProfilePostsLoadingState());
    _userPostsSubscription?.cancel();
    _userPostsSubscription = postRepo.getUserPosts(userId).listen(
      (postsList) {
        userPosts = postsList;
        emit(HomeGetProfilePostsSuccessState(postsList));
      },
      onError: (dynamic e) => emit(HomeGetProfilePostsErrorState(e.toString())),
    );
  }

  Future<void> updateProfile() async {
    if (userModel == null) return;
    emit(HomeUpdateProfileLoadingState());
    try {
      String profileUrl = userModel!.photoUrl!;
      String coverUrl = userModel!.coverUrl!;

      if (profileImage != null) {
        profileUrl = await uploadImageToCloudinary(profileImage!);
      }
      if (coverImage != null) {
        coverUrl = await uploadImageToCloudinary(coverImage!);
      }

      final updatedUser = userModel!.copyWith(
        username: usernameController.text.trim(),
        bio: bioController.text.trim(),
        photoUrl: profileUrl,
        coverUrl: coverUrl,
      );

      await userRepo.updateUser(updatedUser);
      await postRepo.updateUserPosts(
        userId: updatedUser.uid!,
        username: updatedUser.username!,
        userProfilePic: updatedUser.photoUrl!,
      );

      userModel = updatedUser;
      profileImage = null;
      coverImage = null;
      emit(HomeUpdateProfileSuccessState());
    } catch (e) {
      emit(HomeUpdateProfileErrorState(e.toString()));
    }
  }

  // --- Social Actions ---

  Future<void> followUser(String userIdToFollow) async {
    if (userModel == null) return;
    emit(HomeFollowUserLoadingState());
    try {
      await userRepo.followUser(userModel!.uid!, userIdToFollow);
      await _sendNotification(
        receiverId: userIdToFollow,
        type: 'follow',
        arMsg: "بدأ بمتابعتك 👤",
        enMsg: "started following you 👤",
      );
      await getUserData();
      emit(HomeFollowUserSuccessState());
    } catch (e) {
      emit(HomeFollowUserErrorState(e.toString()));
    }
  }

  Future<void> unfollowUser(String userIdToUnfollow) async {
    if (userModel == null) return;
    emit(HomeUnfollowUserLoadingState());
    try {
      await userRepo.unfollowUser(userModel!.uid!, userIdToUnfollow);
      await getUserData();
      emit(HomeUnfollowUserSuccessState());
    } catch (e) {
      emit(HomeUnfollowUserErrorState(e.toString()));
    }
  }

  // --- Notifications ---

  void getNotifications() {
    if (userModel == null) return;
    emit(HomeGetNotificationsLoadingState());
    _notificationsSubscription?.cancel();
    _notificationsSubscription = notificationRepo
        .getUserNotifications(userModel!.uid!)
        .listen(
          (event) {
            notifications = event;
            unreadNotificationsCount = notifications
                .where((n) => !n.isRead)
                .length;
            emit(HomeGetNotificationsSuccessState(event));
          },
          onError: (dynamic e) =>
              emit(HomeGetNotificationsErrorState(e.toString())),
        );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationRepo.markNotificationAsRead(notificationId);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _sendNotification({
    required String receiverId,
    required String type,
    required String arMsg,
    required String enMsg,
    String? postId,
    String? content,
  }) async {
    await NotificationService.send(
      receiverId: receiverId,
      title: userModel!.username!,
      contents: {"en": enMsg, "ar": arMsg},
      data: {"type": type, "postId": postId ?? "", "senderId": userModel!.uid!},
    );
    await notificationRepo.sendNotification(
      senderId: userModel!.uid!,
      senderName: userModel!.username!,
      senderProfilePic: userModel!.photoUrl!,
      receiverId: receiverId,
      type: type,
      postId: postId,
      text: content != null ? '$enMsg: $content' : enMsg,
    );
  }

  // --- Helpers & UI State ---

  void toggleEmojiPicker() {
    isEmojiVisible = !isEmojiVisible;
    emit(HomeToggleEmojiPickerState());
  }

  Future<void> pickPostImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(HomePickPostImageState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(HomeRemovePostImageState());
  }

  Future<String> uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'dvv07qlxn';
    const uploadPreset = 'userProfile';
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['secure_url'];
    } else {
      throw Exception(appTranslation().get('upload_failed'));
    }
  }

  void initEditPost(PostModel post) {
    editPostController.text = post.text ?? '';
    editPostImage = null;
    editPostImageUrl = post.imageUrl;
    emit(HomeInitEditPostState());
  }

  Future<void> updatePost({required String postId}) async {
    emit(HomeUpdatePostLoadingState());
    try {
      String? imageUrl = editPostImageUrl;
      if (editPostImage != null) {
        imageUrl = await uploadImageToCloudinary(editPostImage!);
      }

      await postRepo.updatePost(
        postId: postId,
        text: editPostController.text.trim(),
        imageUrl: imageUrl,
      );

      editPostController.clear();
      editPostImage = null;
      emit(HomeUpdatePostSuccessState());
    } catch (e) {
      emit(HomeUpdatePostErrorState(e.toString()));
    }
  }

  Future<void> pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(HomeProfileImagePickedState());
    }
  }

  Future<void> pickCoverImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(HomeCoverImagePickedState());
    }
  }

  Future<void> pickEditPostImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      editPostImage = File(pickedFile.path);
      emit(HomeInitEditPostState());
    }
  }

  void removeEditPostImage() {
    editPostImage = null;
    editPostImageUrl = null;
    emit(HomeRemoveEditPostImageState());
  }

  Future<void> deletePost(String postId) async {
    emit(HomeDeletePostLoadingState());
    try {
      await postRepo.deletePost(postId);
      posts.removeWhere((p) => p.postId == postId);
      emit(HomeDeletePostSuccessState());
    } catch (e) {
      emit(HomeDeletePostErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    _userPostsSubscription?.cancel();
    _notificationsSubscription?.cancel();

    postTextController.dispose();
    commentController.dispose();
    editPostController.dispose();
    usernameController.dispose();
    bioController.dispose();

    return super.close();
  }
}
