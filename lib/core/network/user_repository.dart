import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ripple/core/models/user_model.dart';

class UserRepository {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  /// ----------------------------
  /// GET USER STREAM (for real-time updates)
  /// ----------------------------
  Stream<UserModel?> getUserStream(String uid) {
    return users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
    });
  }

  /// ----------------------------
  /// CREATE USER DOCUMENT
  /// ----------------------------
  Future<void> createUser(UserModel user) async {
    await users.doc(user.uid).set(user.toMap());
  }

  /// ----------------------------
  /// UPDATE USER DATA
  /// (name, bio, photo, username, token…)
  /// ----------------------------
  Future<void> updateUser(UserModel user) async {
    await users.doc(user.uid).update(user.toMap());
  }

  /// ----------------------------
  /// UPDATE a single field
  /// ----------------------------
  Future<void> updateUserField(String uid, Map<String, Object?> data) async {
    await users.doc(uid).update(data);
  }

  /// ----------------------------
  /// GET USER DATA
  /// ----------------------------
  Future<UserModel?> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
  }

  Future<void> followUser(String currentUserId, String userIdToFollow) async {
    await users.doc(currentUserId).update({
      'following': FieldValue.arrayUnion([userIdToFollow]),
    });
    await users.doc(userIdToFollow).update({
      'followers': FieldValue.arrayUnion([currentUserId]),
    });
  }

  Future<void> unfollowUser(
    String currentUserId,
    String userIdToUnfollow,
  ) async {
    await users.doc(currentUserId).update({
      'following': FieldValue.arrayRemove([userIdToUnfollow]),
    });
    await users.doc(userIdToUnfollow).update({
      'followers': FieldValue.arrayRemove([currentUserId]),
    });
  }

  /// ----------------------------
  /// CHECK IF USER EXISTS
  /// ----------------------------
  Future<bool> userExists(String uid) async {
    final doc = await users.doc(uid).get();
    return doc.exists;
  }

  /// ----------------------------
  /// CHECK IF USERNAME EXISTS
  /// ----------------------------
  Future<bool> usernameExists(String username) async {
    final result = await users
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  /// ----------------------------
  /// DELETE USER DATA
  /// (لو حبيت تعمل حذف كامل)
  /// ----------------------------
  Future<void> deleteUser(String uid) async {
    await users.doc(uid).delete();
  }
}
