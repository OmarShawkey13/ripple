import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addPost({
    required String userId,
    required String username,
    required String userProfilePic,
    String? text,
    String? imageUrl,
  }) async {
    final postRef = _firestore.collection('posts').doc();

    final newPost = PostModel(
      postId: postRef.id,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      timestamp: Timestamp.now(),
      text: text,
      imageUrl: imageUrl,
      likes: [],
      comments: [],
    );

    await postRef.set(newPost.toMap());
  }

  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<PostModel> getPostStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) => PostModel.fromMap(doc.data()!, doc.id));
  }

  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> toggleLike({
    required String postId,
    required String currentUserId,
    required List<String> likes,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);

    if (likes.contains(currentUserId)) {
      await postRef.update({
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String username,
    required String userProfilePic,
    required String text,
  }) async {
    final commentId = const Uuid().v4();
    final comment = CommentModel(
      commentId: commentId,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      text: text,
      timestamp: Timestamp.now(),
      replies: [],
    );

    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }

  Future<void> addReply({
    required String postId,
    required String commentId,
    required String userId,
    required String username,
    required String userProfilePic,
    required String text,
  }) async {
    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (!postDoc.exists) return;

    final post = PostModel.fromMap(postDoc.data()!, postDoc.id);
    final comments = List<CommentModel>.from(post.comments);

    final commentIndex = comments.indexWhere((c) => c.commentId == commentId);
    if (commentIndex == -1) return;

    final replyId = const Uuid().v4();
    final reply = CommentModel(
      commentId: replyId,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      text: text,
      timestamp: Timestamp.now(),
      replies: [],
    );

    final updatedComment = comments[commentIndex].copyWith(
      replies: [...comments[commentIndex].replies, reply],
    );

    comments[commentIndex] = updatedComment;

    await _firestore.collection('posts').doc(postId).update({
      'comments': comments.map((c) => c.toMap()).toList(),
    });
  }

  Future<void> deleteComment({
    required String postId,
    required CommentModel comment,
  }) async {
    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayRemove([comment.toMap()]),
    });
  }

  Future<void> updateUserPosts({
    required String userId,
    required String username,
    required String userProfilePic,
  }) async {
    final posts = await _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();
    final batch = _firestore.batch();
    for (final doc in posts.docs) {
      batch.update(doc.reference, {
        'username': username,
        'userProfilePic': userProfilePic,
      });
    }
    await batch.commit();
  }

  Future<void> updatePost({
    required String postId,
    required String text,
    String? imageUrl,
  }) async {
    await _firestore.collection('posts').doc(postId).update({
      'text': text,
      'imageUrl': imageUrl,
    });
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
