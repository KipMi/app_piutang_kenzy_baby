import 'package:app_piutang_kenzy_baby/add_item/add_item_model.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class AddItemService {
  final Logger _logger = Logger('AddItemService');
  final FirebaseFirestore firestore;
  late final CollectionReference _itemCollection;

  AddItemService({required this.firestore}) {
    _itemCollection = firestore.collection('add_items');
  }

  Future<String> addItem(Map<String, int> items) async {
    // Add item to database
    try {
      DocumentReference docRef = _itemCollection.doc();

      AddItem newItem = AddItem(id: docRef.id, selectedItems: items);

      await docRef.set(newItem.toMap());
      return docRef.id;
    } catch (e) {
      _logger.severe('Failed to add item: ${e.toString()}');
      return '';
    }
  }

  Stream<QuerySnapshot> getAllItems() {
    return _itemCollection.snapshots();
  }

  Future<AddItem?> getItem(String id) async {
    try {
      DocumentSnapshot doc = await _itemCollection.doc(id).get();
      if (doc.exists) {
        return AddItem.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read item: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateItem(String id, AddItem item) async {
    try {
      await _itemCollection.doc(id).update(item.toMap());
    } catch (e) {
      _logger.severe('Failed to update item: ${e.toString()}');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _itemCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete item: ${e.toString()}');
    }
  }
}
