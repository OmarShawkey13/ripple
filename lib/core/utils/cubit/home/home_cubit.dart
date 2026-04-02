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

  UserModel? userModel;
  UserModel? viewedUserModel;

  Future<void> cacheUser(UserModel? model) async {
    final json = jsonEncode(model!.toMap());
    await CacheHelper.saveData(key: 'userModel', value: json);
  }

  UserModel? getCachedUser() {
    final json = CacheHelper.getData(key: 'userModel');
    if (json == null) return null;
    return UserModel.fromMap(
      jsonDecode(json),
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void listenToUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _userSubscription?.cancel();

    _userSubscription = userRepo
        .getUserStream(uid)
        .listen(
          (user) async {
            if (user == null) return;

            final currentToken = await FirebaseMessaging.instance.getToken();

            if (user.fcmToken != currentToken) {
              logout(navigatorKey.currentContext!);
              return;
            }

            userModel = user;
            await cacheUser(user);
            emit(HomeGetCurrentUserSuccessState());
          },
          onError: (dynamic error) {
            emit(HomeGetCurrentUserErrorState(error.toString()));
          },
        );
  }

  Future<void> getUserData() async {
    final cached = getCachedUser();
    if (cached != null) {
      userModel = cached;
      emit(HomeGetCurrentUserSuccessState());
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final fresh = await userRepo.getUser(uid);
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null && fresh!.fcmToken != token) {
        final updatedUser = fresh.copyWith(fcmToken: token);
        await userRepo.updateUser(updatedUser);
        userModel = updatedUser;
      } else {
        userModel = fresh;
      }

      await cacheUser(userModel);
      emit(HomeGetCurrentUserSuccessState());
    } catch (e) {
      if (cached == null) {
        emit(HomeGetCurrentUserErrorState(e.toString()));
      }
    }
  }

  Future<void> getOtherUserData(String userId) async {
    emit(HomeGetViewedUserLoadingState());
    try {
      final user = await userRepo.getUser(userId);
      viewedUserModel = user;
      emit(HomeGetViewedUserSuccessState());
    } catch (e) {
      emit(HomeGetViewedUserErrorState(e.toString()));
    }
  }

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

  final EmojiTextEditingController postTextController = .new();
  List<PostModel> posts = [];
  File? postImage;

  Future<void> pickPostImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(HomePickPostImageState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(HomeRemovePostImageState());
  }

  Future<void> addPost(String text) async {
    if (userModel == null) {
      emit(HomeAddPostErrorState("User not logged in"));
      return;
    }
    emit(HomeAddPostLoadingState());
    try {
      String? imageUrl;
      if (postImage != null) {
        imageUrl = await uploadImageToCloudinary(postImage!);
      }

      await postRepo.addPost(
        userId: userModel!.uid!,
        username: userModel!.username!,
        userProfilePic: userModel!.photoUrl!,
        text: text,
        imageUrl: imageUrl,
      );

      postImage = null;
      postTextController.clear();
      emit(HomeAddPostSuccessState());
    } catch (e) {
      emit(HomeAddPostErrorState(e.toString()));
    }
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
      final data = jsonDecode(res.body);
      return data['secure_url'];
    } else {
      throw Exception('Cloudinary upload failed');
    }
  }

  void getPosts() {
    emit(HomeGetFeedPostsLoadingState());
    try {
      postRepo.getPosts().listen((posts) {
        this.posts = posts;
        emit(HomeGetFeedPostsSuccessState(posts));
      });
    } catch (e) {
      emit(HomeGetFeedPostsErrorState(e.toString()));
    }
  }

  Stream<PostModel> getPostStream(String postId) {
    return postRepo.getPostStream(postId);
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
        await NotificationService.send(
          receiverId: post.userId,
          title: userModel!.username!,
          contents: {"en": "liked your post ❤️", "ar": "أعجب بمنشورك ❤️"},
          data: {
            "type": "like",
            "postId": post.postId,
            "senderId": userModel!.uid!,
          },
        );
        await notificationRepo.sendNotification(
          senderId: userModel!.uid!,
          senderName: userModel!.username!,
          senderProfilePic: userModel!.photoUrl!,
          receiverId: post.userId,
          type: 'like',
          postId: post.postId,
          text: 'liked your post ❤️',
        );
      }
      emit(HomeLikePostSuccessState());
    } catch (e) {
      emit(HomeLikePostErrorState(e.toString()));
    }
  }

  final EmojiTextEditingController commentController = .new();

  Future<void> addComment(String postId, String postOwnerId) async {
    if (userModel == null) {
      emit(HomeAddCommentErrorState("User not logged in"));
      return;
    }
    emit(HomeAddCommentLoadingState());
    try {
      await postRepo.addComment(
        postId: postId,
        userId: userModel!.uid!,
        username: userModel!.username!,
        userProfilePic: userModel!.photoUrl!,
        text: commentController.text.trim(),
      );
      if (postOwnerId != userModel!.uid) {
        await NotificationService.send(
          receiverId: postOwnerId,
          title: userModel!.username!,
          contents: {
            "en": "commented on your post 💬",
            "ar": "علّق على منشورك 💬",
          },
          data: {
            "type": "comment",
            "postId": postId,
            "senderId": userModel!.uid!,
          },
        );
        await notificationRepo.sendNotification(
          senderId: userModel!.uid!,
          senderName: userModel!.username!,
          senderProfilePic: userModel!.photoUrl!,
          receiverId: postOwnerId,
          type: 'comment',
          postId: postId,
          text: 'commented on your post: ${commentController.text.trim()}',
        );
      }
      commentController.clear();
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
        await NotificationService.send(
          receiverId: commentOwnerId,
          title: userModel!.username!,
          contents: {
            "en": "replied to your comment 💬",
            "ar": "رد على تعليقك 💬",
          },
          data: {
            "type": "comment",
            "postId": postId,
            "senderId": userModel!.uid!,
          },
        );
        await notificationRepo.sendNotification(
          senderId: userModel!.uid!,
          senderName: userModel!.username!,
          senderProfilePic: userModel!.photoUrl!,
          receiverId: commentOwnerId,
          type: 'comment',
          postId: postId,
          text: 'replied to your comment: $text',
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

  Future<void> followUser(String userIdToFollow) async {
    if (userModel == null) return;
    emit(HomeFollowUserLoadingState());
    try {
      await userRepo.followUser(userModel!.uid!, userIdToFollow);
      await NotificationService.send(
        receiverId: userIdToFollow,
        title: userModel!.username!,
        contents: {"en": "started following you 👤", "ar": "بدأ بمتابعتك 👤"},
        data: {"type": "follow", "senderId": userModel!.uid!},
      );
      await notificationRepo.sendNotification(
        senderId: userModel!.uid!,
        senderName: userModel!.username!,
        senderProfilePic: userModel!.photoUrl!,
        receiverId: userIdToFollow,
        type: 'follow',
        text: 'started following you',
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

  Future<void> deletePost(String postId) async {
    emit(HomeDeletePostLoadingState());
    try {
      await postRepo.deletePost(postId);
      posts.removeWhere((post) => post.postId == postId);
      emit(HomeDeletePostSuccessState());
    } catch (e) {
      emit(HomeDeletePostErrorState(e.toString()));
    }
  }

  void logout(BuildContext context) {
    _userSubscription?.cancel();
    FirebaseAuth.instance.signOut().then((value) {
      if (context.mounted) {
        context.pushReplacement<Object>(Routes.login);
      }
    });
  }

  List<PostModel> userPosts = [];

  void getMyPosts() {
    emit(HomeGetProfilePostsLoadingState());
    try {
      postRepo.getUserPosts(userModel!.uid!).listen((posts) {
        userPosts = posts;
        emit(HomeGetProfilePostsSuccessState(posts));
      });
    } catch (e) {
      emit(HomeGetProfilePostsErrorState(e.toString()));
    }
  }

  void getUserPosts(String userId) {
    emit(HomeGetProfilePostsLoadingState());
    try {
      postRepo.getUserPosts(userId).listen((posts) {
        userPosts = posts;
        emit(HomeGetProfilePostsSuccessState(posts));
      });
    } catch (e) {
      emit(HomeGetProfilePostsErrorState(e.toString()));
    }
  }

  File? profileImage;
  File? coverImage;
  final TextEditingController usernameController = .new();
  final TextEditingController bioController = .new();

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(HomeProfileImagePickedState());
    }
  }

  Future<void> pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(HomeCoverImagePickedState());
    }
  }

  Future<void> updateProfile() async {
    if (userModel == null) return;
    emit(HomeUpdateProfileLoadingState());
    try {
      String profileUrl = userModel!.photoUrl!;
      String coverUrl = userModel!.coverUrl!;
      if (profileImage != null)
        profileUrl = await uploadImageToCloudinary(profileImage!);
      if (coverImage != null)
        coverUrl = await uploadImageToCloudinary(coverImage!);

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

  final EmojiTextEditingController editPostController = .new();
  File? editPostImage;
  String? editPostImageUrl;

  void initEditPost(PostModel post) {
    editPostController.text = post.text ?? '';
    editPostImage = null;
    editPostImageUrl = post.imageUrl;
  }

  Future<void> updatePost({required String postId}) async {
    emit(HomeUpdatePostLoadingState());
    try {
      String? imageUrl;
      final oldPost = posts.firstWhere((p) => p.postId == postId);
      if (editPostImage != null) {
        imageUrl = await uploadImageToCloudinary(editPostImage!);
      } else if (editPostImageUrl == null) {
        imageUrl = null;
      } else {
        imageUrl = oldPost.imageUrl;
      }
      await postRepo.updatePost(
        postId: postId,
        text: editPostController.text.trim(),
        imageUrl: imageUrl,
      );
      final index = posts.indexWhere((p) => p.postId == postId);
      if (index != -1) {
        posts[index] = posts[index].copyWith(
          text: editPostController.text.trim(),
          imageUrl: imageUrl,
        );
      }
      editPostController.clear();
      editPostImage = null;
      editPostImageUrl = null;
      emit(HomeUpdatePostSuccessState());
    } catch (e) {
      emit(HomeUpdatePostErrorState(e.toString()));
    }
  }

  void removeEditPostImage() {
    editPostImage = null;
    editPostImageUrl = null;
    emit(HomeRemoveEditPostImageState());
  }

  List<NotificationModel> notifications = [];
  int unreadNotificationsCount = 0;

  void getNotifications() {
    if (userModel == null) return;
    emit(HomeGetNotificationsLoadingState());
    try {
      notificationRepo.getUserNotifications(userModel!.uid!).listen((event) {
        notifications = event;
        unreadNotificationsCount = notifications.where((n) => !n.isRead).length;
        emit(HomeGetNotificationsSuccessState(event));
      });
    } catch (e) {
      emit(HomeGetNotificationsErrorState(e.toString()));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationRepo.markNotificationAsRead(notificationId);
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
    }
  }
}
