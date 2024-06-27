import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('Error occured: ${e.toString()}');
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('Error occured: ${e.toString()}');
    }

    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUserByUid(String uid) async {
    try {
      await _auth.currentUser?.delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error occurred while deleting user: ${e.toString()}');
    }
  }
}
