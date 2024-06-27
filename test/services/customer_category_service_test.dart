import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_model.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';

void main() {
  group('CustomerCategoryService', () {
    late CustomerCategoryService customerCategoryService;
    late FakeFirebaseFirestore fakeFirestore;
    late CustomerCategory testCustomerCategory;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      customerCategoryService =
          CustomerCategoryService(firestore: fakeFirestore);
      testCustomerCategory = CustomerCategory(
          createdAt: 1234567, name: 'test name', status: 'test status');
    });

    test('CreateCustomerCategory', () async {
      await customerCategoryService
          .createCustomerCategory(testCustomerCategory);
      final snapshot =
          await fakeFirestore.collection('customer_categories').get();

      final doc = snapshot.docs.first;
      print(doc.data());

      final docDataWithoutId = {...doc.data(), 'id': ''};

      final createdCustomerCategory = CustomerCategory.fromMap(doc.data());
      print('Created customer category: ${createdCustomerCategory.toMap()}');

      expect(snapshot.docs.length, 1);
      expect(docDataWithoutId, testCustomerCategory.toMap());
    });

    test('GetCustomerCategory', () async {
      final testId = 'test doc';

      final docRef =
          await fakeFirestore.collection('customer_categories').doc(testId);
      await docRef.set(testCustomerCategory.toMap());

      await fakeFirestore
          .collection('customer_categories')
          .doc(testId)
          .set(testCustomerCategory.toMap());

      final customerCategory =
          await customerCategoryService.getCustomerCategory(testId);
      final customerCategoryWithoutId = {
        ...customerCategory!.toMap(),
        'id': ''
      };

      print(customerCategory.toMap());

      expect(customerCategory, isNotNull);
      expect(customerCategoryWithoutId, testCustomerCategory.toMap());
    });
  });
}
