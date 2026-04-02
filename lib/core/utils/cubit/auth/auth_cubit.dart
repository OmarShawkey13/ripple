import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/network/user_repository.dart';
import 'package:ripple/core/utils/cubit/auth/auth_state.dart';
import 'package:ripple/main.dart';
import 'package:image_picker/image_picker.dart';

AuthCubit get authCubit => AuthCubit.get(navigatorKey.currentContext!);

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  final UserRepository userRepo = UserRepository();

  final Map<String, bool> _passwordVisibility = {
    'login': false,
    'register': false,
  };

  Map<String, bool> get passwordVisibility => _passwordVisibility;

  void togglePasswordVisibility(String key) {
    _passwordVisibility[key] = !_passwordVisibility[key]!;
    emit(AuthShowPasswordUpdatedState());
  }

  final TextEditingController loginEmailController = .new();
  final TextEditingController loginPasswordController = .new();

  Future<void> login() async {
    emit(AuthLoginLoadingState());
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;

      final fcmToken = await FirebaseMessaging.instance.getToken();
      await userRepo.updateUserField(user.uid, {'fcmToken': fcmToken});

      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser!;

      emit(AuthLoginSuccessState(refreshedUser));
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginErrorState(_mapAuthError(e)));
    } catch (e) {
      emit(AuthLoginErrorState("Something went wrong. Please try again."));
    }
  }

  File? registerProfileImage;
  final TextEditingController registerNameController = .new();
  final TextEditingController registerEmailController = .new();
  final TextEditingController registerPasswordController = .new();

  Future<void> pickRegisterProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      registerProfileImage = File(pickedFile.path);
      emit(AuthProfileImagePickedState());
    }
  }

  Future<void> register() async {
    emit(AuthRegisterLoadingState());

    final email = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();

    try {
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = res.user!;

      String photoUrl = "";
      if (registerProfileImage != null) {
        photoUrl = await uploadImageToCloudinary(registerProfileImage!);
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        username: registerNameController.text.trim(),
        photoUrl: photoUrl,
        coverUrl: "",
        bio: "Hello i'm using Ripple",
        createdAt: DateTime.now(),
      );

      await userRepo.createUser(userModel);

      emit(AuthRegisterSuccessState(user));
      registerProfileImage = null;
      registerNameController.clear();
      registerEmailController.clear();
      registerPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      emit(AuthRegisterErrorState(_mapAuthError(e)));
    } catch (e) {
      emit(AuthRegisterErrorState("Something went wrong. Please try again."));
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
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );
    final response = await request.send();
    final res = await http.Response.fromStream(response);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['secure_url'];
    } else {
      throw Exception('Cloudinary upload failed');
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should be at least 8 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
