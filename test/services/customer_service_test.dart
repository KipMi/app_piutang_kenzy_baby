import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// class MockFireStore extends Mock implements FirebaseFirestore {}

void main() {
  group('CustomerService', () {
    late CustomerService customerService;
    late FakeFirebaseFirestore fakeFirestore;
    late Customer testCustomer;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      customerService = CustomerService(firestore: fakeFirestore);
      testCustomer = Customer(
          createdAt: 123456789,
          address: 'testaddress',
          categoryId: '1',
          expeditionId: '1',
          phoneNumber: 123456789,
          storeName: 'storeName');
    });

    test('createCustomer', () async {
      await customerService.createCustomer(testCustomer);
      final snapshot = await fakeFirestore.collection('customers').get();

      final doc = snapshot.docs.first;
      print(doc.data());

      final docDataWithoutId = {...doc.data(), 'id': ''};

      final createdCustomer = Customer.fromMap(doc.data());

      // Print the created customer
      print('Created customer: ${createdCustomer.toMap()}');

      expect(snapshot.docs.length, 1);
      expect(docDataWithoutId, testCustomer.toMap());
    });

    test('getCustomer', () async {
      final testId = 'test doc';

      final docRef = await fakeFirestore.collection('customers').doc(testId);
      await docRef.set(testCustomer.toMap());

      await fakeFirestore
          .collection('customers')
          .doc(testId)
          .set(testCustomer.toMap());

      final customer = await customerService.getCustomer(testId);
      final customerWithoutId = {...customer!.toMap(), 'id': ''};
      print(customerWithoutId);

      expect(customer, isNotNull);
      expect(customerWithoutId, testCustomer.toMap());
    });
  });
}
