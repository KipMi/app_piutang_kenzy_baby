import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:app_piutang_kenzy_baby/user/user_model.dart';

class UserService {
  final Logger _logger = Logger('UserService');
  final FirebaseFirestore firestore;
  late final CollectionReference _userCollection;

  UserService({required this.firestore}) {
    _userCollection = firestore.collection('users');
  }

  Future<void> createUser(UserData user, String uid) async {
    try {
      DocumentReference docRef = _userCollection.doc(uid);

      UserData newUser = UserData(
          id: uid,
          createdAt: user.createdAt,
          email: user.email,
          password: user.password,
          roleId: user.roleId,
          userAddress: user.userAddress,
          username: user.username);

      await docRef.set(newUser.toMap());
    } catch (e) {
      _logger.severe('Failed to create user: ${e.toString()}');
      return;
    }
  }

  Future<UserData?> getUser(String id) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(id).get();
      if (doc.exists) {
        return UserData.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read user: ${e.toString()}');
      return null;
    }
  }

  Future<String?> getCurrentUserRoleId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return snapshot.data()!['roleId'];
    } else {
      print('User does not exist for ${user.uid}');
      return null;
    }
  }

  Future<String?> getCurrentUserRoleName() async {
    final roleId = await getCurrentUserRoleId();
    if (roleId == null) {
      return null;
    }

    final docRef = FirebaseFirestore.instance.collection('roles').doc(roleId);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return snapshot.data()!['roleName'];
    } else {
      print('Role does not exist for $roleId');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _userCollection.snapshots();
  }

  Future<void> updateUser(String id, UserData customer) async {
    try {
      await _userCollection.doc(id).update(customer.toMap());
    } catch (e) {
      _logger.severe('Failed to update user: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete user: ${e.toString()}');
      return;
    }
  }
}
