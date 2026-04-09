import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // --- Post Core ---

  Future<void> addPost({
    required String userId,
    required String username,
    required String userProfilePic,
    String? text,
    List<String>? imageUrls,
  }) async {
    final postRef = _firestore.collection('posts').doc();
    final newPost = PostModel(
      postId: postRef.id,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      timestamp: Timestamp.now(),
      text: text,
      imageUrls: imageUrls,
      likes: [],
      comments: [], // سنبقيها فارغة في المستند الرئيسي
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

  // --- Likes ---

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

  // --- Comments (Sub-collection) ---

  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String username,
    required String userProfilePic,
    required String text,
  }) async {
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();
    final comment = CommentModel(
      commentId: commentRef.id,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      text: text,
      timestamp: Timestamp.now(),
      replies: [],
    );
    await commentRef.set(comment.toMap());
  }

  // --- Replies (Sub-collection inside Comment) ---

  Stream<List<CommentModel>> getRepliesStream(String postId, String commentId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addReply({
    required String postId,
    required String commentId,
    required String userId,
    required String username,
    required String userProfilePic,
    required String text,
  }) async {
    final replyRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc();

    final reply = CommentModel(
      commentId: replyRef.id,
      userId: userId,
      username: username,
      userProfilePic: userProfilePic,
      text: text,
      timestamp: Timestamp.now(),
      replies: [],
    );
    await replyRef.set(reply.toMap());
  }

  Future<void> deleteComment({
    required String postId,
    required CommentModel comment,
  }) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.commentId)
        .delete();
  }

  // --- Updates & Deletes ---

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
    List<String>? imageUrls,
  }) async {
    await _firestore.collection('posts').doc(postId).update({
      'text': text,
      'imageUrls': imageUrls,
    });
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
