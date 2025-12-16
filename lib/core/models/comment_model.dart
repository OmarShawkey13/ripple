import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String username;
  final String userProfilePic;
  final String text;
  final Timestamp timestamp;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.text,
    required this.timestamp,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String commentId) {
    return CommentModel(
      commentId: commentId,
      userId: map['userId'] as String,
      username: map['username'] as String,
      userProfilePic: map['userProfilePic'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
