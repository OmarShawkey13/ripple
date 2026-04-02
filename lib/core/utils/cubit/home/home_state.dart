import 'package:ripple/core/models/notification_model.dart';
import 'package:ripple/core/models/post_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

// Current User States (Me)
class HomeGetCurrentUserLoadingState extends HomeStates {}

class HomeGetCurrentUserSuccessState extends HomeStates {}

class HomeGetCurrentUserErrorState extends HomeStates {
  final String error;
  HomeGetCurrentUserErrorState(this.error);
}

// Viewed User States (Others/Profile)
class HomeGetViewedUserLoadingState extends HomeStates {}

class HomeGetViewedUserSuccessState extends HomeStates {}

class HomeGetViewedUserErrorState extends HomeStates {
  final String error;
  HomeGetViewedUserErrorState(this.error);
}

// Post Creation States
class HomeAddPostLoadingState extends HomeStates {}

class HomeAddPostSuccessState extends HomeStates {}

class HomeAddPostErrorState extends HomeStates {
  final String error;
  HomeAddPostErrorState(this.error);
}

class HomePickPostImageState extends HomeStates {}

class HomeRemovePostImageState extends HomeStates {}

class HomeToggleEmojiPickerState extends HomeStates {}

// Feed Posts States
class HomeGetFeedPostsLoadingState extends HomeStates {}

class HomeGetFeedPostsSuccessState extends HomeStates {
  final List<PostModel> posts;
  HomeGetFeedPostsSuccessState(this.posts);
}

class HomeGetFeedPostsErrorState extends HomeStates {
  final String error;
  HomeGetFeedPostsErrorState(this.error);
}

// Profile Posts States
class HomeGetProfilePostsLoadingState extends HomeStates {}

class HomeGetProfilePostsSuccessState extends HomeStates {
  final List<PostModel> posts;
  HomeGetProfilePostsSuccessState(this.posts);
}

class HomeGetProfilePostsErrorState extends HomeStates {
  final String error;
  HomeGetProfilePostsErrorState(this.error);
}

// Interaction States
class HomeLikePostSuccessState extends HomeStates {}

class HomeLikePostErrorState extends HomeStates {
  final String error;
  HomeLikePostErrorState(this.error);
}

// Comment States
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

// Follow/Unfollow States
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

// Post Management States
class HomeDeletePostLoadingState extends HomeStates {}

class HomeDeletePostSuccessState extends HomeStates {}

class HomeDeletePostErrorState extends HomeStates {
  final String error;
  HomeDeletePostErrorState(this.error);
}

class HomeUpdatePostLoadingState extends HomeStates {}

class HomeUpdatePostSuccessState extends HomeStates {}

class HomeUpdatePostErrorState extends HomeStates {
  final String error;
  HomeUpdatePostErrorState(this.error);
}

class HomeRemoveEditPostImageState extends HomeStates {}

// Profile Update States
class HomeProfileImagePickedState extends HomeStates {}

class HomeCoverImagePickedState extends HomeStates {}

class HomeUpdateProfileLoadingState extends HomeStates {}

class HomeUpdateProfileSuccessState extends HomeStates {}

class HomeUpdateProfileErrorState extends HomeStates {
  final String error;
  HomeUpdateProfileErrorState(this.error);
}

// Notification States
class HomeGetNotificationsLoadingState extends HomeStates {}

class HomeGetNotificationsSuccessState extends HomeStates {
  final List<NotificationModel> notifications;
  HomeGetNotificationsSuccessState(this.notifications);
}

class HomeGetNotificationsErrorState extends HomeStates {
  final String error;
  HomeGetNotificationsErrorState(this.error);
}

class HomeInitEditPostState extends HomeStates {}
