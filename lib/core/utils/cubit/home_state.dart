import 'package:firebase_auth/firebase_auth.dart';
import 'package:ripple/core/models/notification_model.dart';
import 'package:ripple/core/models/post_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeThemeState extends HomeStates {}

class HomeLanguageUpdatedState extends HomeStates {}

class HomeLanguageLoadingState extends HomeStates {}

class HomeLanguageLoadedState extends HomeStates {}

class HomeLanguageErrorState extends HomeStates {
  final String error;

  HomeLanguageErrorState(this.error);
}

class HomeShowPasswordUpdatedState extends HomeStates {}

//login
class HomeLoginLoadingState extends HomeStates {}

class HomeLoginSuccessState extends HomeStates {
  final User? user;

  HomeLoginSuccessState(this.user);
}

class HomeLoginErrorState extends HomeStates {
  final String error;

  HomeLoginErrorState(this.error);
}

//register
class HomeProfileImagePickedState extends HomeStates {}

class HomeRegisterLoadingState extends HomeStates {}

class HomeRegisterSuccessState extends HomeStates {
  final User? user;

  HomeRegisterSuccessState(this.user);
}

class HomeRegisterErrorState extends HomeStates {
  final String error;

  HomeRegisterErrorState(this.error);
}

//getUserData
class HomeGetUserSuccessState extends HomeStates {}

class HomeGetUserErrorState extends HomeStates {
  final String error;

  HomeGetUserErrorState(this.error);
}

// Posts
class HomeGetPostsLoadingState extends HomeStates {}

class HomeGetPostsSuccessState extends HomeStates {
  final List<PostModel> posts;

  HomeGetPostsSuccessState(this.posts);
}

class HomeGetPostsErrorState extends HomeStates {
  final String error;

  HomeGetPostsErrorState(this.error);
}

class HomeAddPostLoadingState extends HomeStates {}

class HomeAddPostSuccessState extends HomeStates {}

class HomeAddPostErrorState extends HomeStates {
  final String error;

  HomeAddPostErrorState(this.error);
}

class HomeRemovePostImageState extends HomeStates {}

class HomePickPostImageState extends HomeStates {}

// Like Post
class HomeLikePostSuccessState extends HomeStates {}

class HomeLikePostErrorState extends HomeStates {
  final String error;

  HomeLikePostErrorState(this.error);
}

// Comments
class HomeAddCommentLoadingState extends HomeStates {}

class HomeAddCommentSuccessState extends HomeStates {}

class HomeAddCommentErrorState extends HomeStates {
  final String error;

  HomeAddCommentErrorState(this.error);
}

class HomeDeleteCommentLoadingState extends HomeStates {}

class HomeDeleteCommentSuccessState extends HomeStates {}

class HomeDeleteCommentErrorState extends HomeStates {
  final String error;

  HomeDeleteCommentErrorState(this.error);
}

//myPosts
class HomeGetMyPostsLoadingState extends HomeStates {}

class HomeGetMyPostsSuccessState extends HomeStates {
  final List<PostModel> posts;

  HomeGetMyPostsSuccessState(this.posts);
}

class HomeGetMyPostsErrorState extends HomeStates {
  final String error;

  HomeGetMyPostsErrorState(this.error);
}

// Edit Profile
class HomePickProfileImageState extends HomeStates {}

class HomePickCoverImageState extends HomeStates {}

class HomeUpdateProfileLoadingState extends HomeStates {}

class HomeUpdateProfileSuccessState extends HomeStates {}

class HomeUpdateProfileErrorState extends HomeStates {
  final String error;

  HomeUpdateProfileErrorState(this.error);
}

class HomeCoverImagePickedState extends HomeStates {}

// Edit Post
class HomeRemoveEditPostImageState extends HomeStates {}

class HomeUpdatePostLoadingState extends HomeStates {}

class HomeUpdatePostSuccessState extends HomeStates {}

class HomeUpdatePostErrorState extends HomeStates {
  final String error;

  HomeUpdatePostErrorState(this.error);
}

// Follow
class HomeFollowUserLoadingState extends HomeStates {}

class HomeFollowUserSuccessState extends HomeStates {}

class HomeFollowUserErrorState extends HomeStates {
  final String error;

  HomeFollowUserErrorState(this.error);
}

class HomeUnfollowUserLoadingState extends HomeStates {}

class HomeUnfollowUserSuccessState extends HomeStates {}

class HomeUnfollowUserErrorState extends HomeStates {
  final String error;

  HomeUnfollowUserErrorState(this.error);
}

// Delete Post
class HomeDeletePostLoadingState extends HomeStates {}

class HomeDeletePostSuccessState extends HomeStates {}

class HomeDeletePostErrorState extends HomeStates {
  final String error;

  HomeDeletePostErrorState(this.error);
}

// Notifications
class HomeGetNotificationsLoadingState extends HomeStates {}

class HomeGetNotificationsSuccessState extends HomeStates {
  final List<NotificationModel> notifications;

  HomeGetNotificationsSuccessState(this.notifications);
}

class HomeGetNotificationsErrorState extends HomeStates {
  final String error;

  HomeGetNotificationsErrorState(this.error);
}
