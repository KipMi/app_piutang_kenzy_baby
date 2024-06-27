import 'item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class ItemService {
  final Logger _logger = Logger('ItemService');
  final FirebaseFirestore firestore;
  late final CollectionReference _itemCollection;

  bool hasError = false;
  String errorMessage = '';

  ItemService({required this.firestore}) {
    _itemCollection = firestore.collection('items');
  }

  Future<void> createItem(Item item) async {
    try {
      final querySnapshot = await _itemCollection
          .where('articleCode', isEqualTo: item.articleCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        hasError = true;
        errorMessage = 'Item with the same article code already exists';
        return;
      }

      DocumentReference docRef = _itemCollection.doc();

      Item newItem = Item(
          id: docRef.id,
          articleCode: item.articleCode,
          itemName: item.itemName,
          price: item.price,
          totalStock: item.totalStock);

      await docRef.set(newItem.toMap());
    } catch (e) {
      _logger.severe('Failed to create item: ${e.toString()}');
    }
  }

  Stream<QuerySnapshot> getAllItems() {
    return _itemCollection.snapshots();
  }

  Future<Item?> getItem(String id) async {
    try {
      DocumentSnapshot doc = await _itemCollection.doc(id).get();
      if (doc.exists) {
        return Item.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read item: ${e.toString()}');
      return null;
    }
  }

  Future<void> updateItem(String id, Item item) async {
    try {
      await _itemCollection.doc(id).update(item.toMap());
    } catch (e) {
      _logger.severe('Failed to update item: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _itemCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete item: ${e.toString()}');
      return;
    }
  }
}
