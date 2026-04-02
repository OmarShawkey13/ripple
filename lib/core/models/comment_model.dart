import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String username;
  final String userProfilePic;
  final String text;
  final Timestamp timestamp;
  final List<CommentModel> replies;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.text,
    required this.timestamp,
    this.replies = const [],
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String commentId) {
    return CommentModel(
      commentId: commentId,
      userId: map['userId'] as String,
      username: map['username'] as String,
      userProfilePic: map['userProfilePic'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as Timestamp,
      replies: (map['replies'] as List<dynamic>? ?? [])
          .asMap()
          .entries
          .map((e) => CommentModel.fromMap(e.value, e.key.toString()))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'text': text,
      'timestamp': timestamp,
      'replies': replies.map((r) => r.toMap()).toList(),
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? userId,
    String? username,
    String? userProfilePic,
    String? text,
    Timestamp? timestamp,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfilePic: userProfilePic ?? this.userProfilePic,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      replies: replies ?? this.replies,
    );
  }
}
