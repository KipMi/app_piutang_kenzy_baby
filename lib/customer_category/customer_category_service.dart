import 'package:app_piutang_kenzy_baby/customer_category/customer_category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class CustomerCategoryService {
  final Logger _logger = Logger('CustomerCategoryService');
  final FirebaseFirestore firestore;
  late final CollectionReference _customerCategoryCollection;

  CustomerCategoryService({required this.firestore}) {
    _customerCategoryCollection = firestore.collection('customer_categories');
  }

  Future<void> createCustomerCategory(CustomerCategory customerCategory) async {
    try {
      DocumentReference docRef = _customerCategoryCollection.doc();

      CustomerCategory newCustomerCategory = CustomerCategory(
        id: docRef.id,
        createdAt: customerCategory.createdAt,
        name: customerCategory.name,
        status: customerCategory.status,
      );

      await docRef.set(newCustomerCategory.toMap());
      // await _customerCategoryCollection.add(customer.toMap());
    } catch (e) {
      _logger.severe('Failed to create customer category: ${e.toString()}');
      return;
    }
  }

  Future<CustomerCategory?> getCustomerCategory(String id) async {
    try {
      DocumentSnapshot doc = await _customerCategoryCollection.doc(id).get();
      if (doc.exists) {
        return CustomerCategory.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read customer: ${e.toString()}');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllCustomerCategories() {
    return _customerCategoryCollection.snapshots();
  }

  Future<void> updateCustomerCategory(
      String id, CustomerCategory customer) async {
    try {
      await _customerCategoryCollection.doc(id).update(customer.toMap());
    } catch (e) {
      _logger.severe('Failed to update customer: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteCustomerCategory(String id) async {
    try {
      await _customerCategoryCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete customer: ${e.toString()}');
      return;
    }
  }
}
