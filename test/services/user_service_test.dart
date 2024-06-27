import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_piutang_kenzy_baby/user/user_model.dart';
import 'package:app_piutang_kenzy_baby/user/user_service.dart';

void main() {
  group('UserService', () {
    late UserService userService;
    late FakeFirebaseFirestore fakeFirestore;
    late UserData testUser;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      userService = UserService(firestore: fakeFirestore);
      testUser = UserData(
          createdAt: 12345,
          email: 'test@email.com',
          password: 'test123',
          roleId: 1,
          userAddress: 'test address',
          username: 'test username');
    });

    test('createUser', () async {
      await userService.createUser(testUser);
      final snapshot = await fakeFirestore.collection('users').get();

      final doc = snapshot.docs.first;
      print(doc.data());

      final docDataWithoutId = {...doc.data(), 'id': ''};

      final createdUser = UserData.fromMap(doc.data());

      print(createdUser);

      expect(snapshot.docs.length, 1);
      expect(docDataWithoutId, testUser.toMap());
    });

    test('getUser', () async {
      final testId = 'test doc';

      final docRef = await fakeFirestore.collection('users').doc(testId);
      await docRef.set(testUser.toMap());

      await fakeFirestore.collection('users').doc(testId).set(testUser.toMap());

      final user = await userService.getUser(testId);
      final userWithoutId = {...user!.toMap(), 'id': ''};

      expect(user, isNotNull);
      expect(userWithoutId, testUser.toMap());
    });
  });
}
