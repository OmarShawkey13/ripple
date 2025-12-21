import 'package:flutter/material.dart';
import 'package:ripple/features/entry/presentation/screen/entry_screen.dart';
import 'package:ripple/features/home/presentation/widgets/comments_screen.dart';
import 'package:ripple/features/home/presentation/screen/home_screen.dart';
import 'package:ripple/features/home/presentation/widgets/add_post_screen.dart';
import 'package:ripple/features/home/presentation/widgets/edit_post_screen.dart';
import 'package:ripple/features/home/presentation/widgets/notifications_screen.dart';
import 'package:ripple/features/login/presentation/screen/login_screen.dart';
import 'package:ripple/features/on_boarding/presentation/screen/on_boarding_screen.dart';
import 'package:ripple/features/profile/presentation/screen/profile_screen.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile_screen.dart';
import 'package:ripple/features/register/presentation/screen/register_screen.dart';
import 'package:ripple/features/settings/presentation/screen/settings_screen.dart';

class Routes {
  static const String entry = "/entry";
  static const String onBoarding = "/on_boarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String settings = "/settings";
  static const String profile = "/profile";
  static const String editProfile = "/edit_profile";
  static const String addPost = "/add_post";
  static const String editPost = "/edit_post";
  static const String comments = "/comments";
  static const String notifications = "/notifications";

  static Map<String, WidgetBuilder> get routes => {
    entry: (context) => const EntryScreen(),
    onBoarding: (context) => const OnBoardingScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => const HomeScreen(),
    settings: (context) => const SettingsScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    addPost: (context) => const AddPostScreen(),
    editPost: (context) => const EditPostScreen(),
    comments: (context) => const CommentsScreen(),
    notifications: (context) => const NotificationsScreen(),
  };
}
