import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? username;
  final String? photoUrl;
  final String? coverUrl;
  final String? bio;
  final DateTime? createdAt;
  final List<String> followers;
  final List<String> following;
  final String? fcmToken; // تمت الإضافة

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.photoUrl,
    required this.coverUrl,
    required this.bio,
    this.createdAt,
    this.followers = const [],
    this.following = const [],
    this.fcmToken, // تمت الإضافة
  });

  /// ------------ Firestore → Model ------------
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: parseDate(map["createdAt"]),
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      fcmToken: map['fcmToken'], // تمت الإضافة
    );
  }

  /// ------------ Model → Firestore / JSON ------------
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
      'bio': bio,
      'createdAt': createdAt?.toIso8601String(),
      'followers': followers,
      'following': following,
      'fcmToken': fcmToken, // تمت الإضافة
    };
  }

  /// ------------ CopyWith ------------
  UserModel copyWith({
    String? email,
    String? username,
    String? photoUrl,
    String? coverUrl,
    String? bio,
    DateTime? createdAt,
    List<String>? followers,
    List<String>? following,
    String? fcmToken, // تمت الإضافة
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      fcmToken: fcmToken ?? this.fcmToken, // تمت الإضافة
    );
  }
}
