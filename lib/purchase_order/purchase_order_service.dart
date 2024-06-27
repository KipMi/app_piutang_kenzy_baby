import 'package:app_piutang_kenzy_baby/add_item/add_item_service.dart';
import 'package:uuid/uuid.dart';

import 'purchase_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class PurchaseOrderService {
  final Logger _logger = Logger('PurchaseOrderService');
  final FirebaseFirestore firestore;
  late final CollectionReference _purchaseOrderCollection;

  PurchaseOrderService({required this.firestore}) {
    _purchaseOrderCollection = firestore.collection('purchase_orders');
  }

  Future<void> createPurchaseOrder(PurchaseOrder purchaseOrder) async {
    try {
      const uuid = Uuid();
      String id = uuid.v1().replaceAll('-', '');
      DocumentReference docRef = _purchaseOrderCollection.doc(id);

      PurchaseOrder newPurchaseOrder = PurchaseOrder(
          id: id,
          poDate: purchaseOrder.poDate,
          customerName: purchaseOrder.customerName,
          salesId: purchaseOrder.salesId,
          itemId: purchaseOrder.itemId,
          price: purchaseOrder.price,
          totalPrice: purchaseOrder.totalPrice,
          discount: purchaseOrder.discount,
          status: purchaseOrder.status,
          payment: purchaseOrder.payment);

      await docRef.set(newPurchaseOrder.toMap());
    } catch (e) {
      _logger.severe('Failed to create purchase order: ${e.toString()}');
    }
  }

  Future<PurchaseOrder?> getPurchaseOrder(String id) async {
    try {
      DocumentSnapshot doc = await _purchaseOrderCollection.doc(id).get();
      if (doc.exists) {
        return PurchaseOrder.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read purchase order: ${e.toString()}');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllPurchaseOrders() {
    return _purchaseOrderCollection.snapshots();
  }

  Future<List<PurchaseOrder>> getAllPurchaseOrdersAsFuture() async {
    final querySnapshot = await _purchaseOrderCollection.snapshots().first;
    return querySnapshot.docs
        .map((doc) => PurchaseOrder.fromSnapshot(doc))
        .toList();
  }

  Future<void> updatePurchaseOrder(
      String id, PurchaseOrder purchaseOrder) async {
    try {
      await _purchaseOrderCollection.doc(id).update(purchaseOrder.toMap());
    } catch (e) {
      _logger.severe('Failed to update purchase order: ${e.toString()}');
      return;
    }
  }

  Future<void> deletePurchaseOrder(String id) async {
    try {
      await _purchaseOrderCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete purchase order: ${e.toString()}');
      return;
    }
  }
}
