import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class CustomerService {
  final Logger _logger = Logger('CustomerService');
  final FirebaseFirestore firestore;
  late final CollectionReference _customerCollection;

  CustomerService({required this.firestore}) {
    _customerCollection = firestore.collection('customers');
  }

  Future<void> createCustomer(Customer customer) async {
    try {
      DocumentReference docRef = _customerCollection.doc();

      Customer newCustomer = Customer(
          id: docRef.id,
          createdAt: customer.createdAt,
          address: customer.address,
          categoryId: customer.categoryId,
          expeditionId: customer.expeditionId,
          phoneNumber: customer.phoneNumber,
          storeName: customer.storeName);

      await docRef.set(newCustomer.toMap());
      // await _customerCollection.add(customer.toMap());
    } catch (e) {
      _logger.severe('Failed to create customer: ${e.toString()}');
      return;
    }
  }

  Future<Customer?> getCustomer(String id) async {
    try {
      DocumentSnapshot doc = await _customerCollection.doc(id).get();
      if (doc.exists) {
        return Customer.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read customer: ${e.toString()}');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllCustomers() {
    return _customerCollection.snapshots();
  }

  Future<List<Customer>> getAllCustomersAsFuture() async {
    final querySnapshot = await _customerCollection.snapshots().first;
    return querySnapshot.docs.map((doc) => Customer.fromSnapshot(doc)).toList();
  }

  Future<void> updateCustomer(String id, Customer customer) async {
    try {
      await _customerCollection.doc(id).update(customer.toMap());
    } catch (e) {
      _logger.severe('Failed to update customer: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _customerCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete customer: ${e.toString()}');
      return;
    }
  }
}
