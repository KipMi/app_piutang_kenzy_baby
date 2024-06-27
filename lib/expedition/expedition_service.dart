import 'expedition_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class ExpeditionService {
  final Logger _logger = Logger('ExpeditionService');
  final FirebaseFirestore firestore;
  late final CollectionReference _expeditionCollection;

  ExpeditionService({required this.firestore}) {
    _expeditionCollection = firestore.collection('expeditions');
  }

  Future<void> createExpedition(Expedition expedition) async {
    try {
      DocumentReference docRef = _expeditionCollection.doc();

      Expedition newExpedition = Expedition(
          id: docRef.id,
          createdAt: expedition.createdAt,
          name: expedition.name,
          status: expedition.status);

      await docRef.set(newExpedition.toMap());
    } catch (e) {
      _logger.severe('Failed to create expedition: ${e.toString()}');
      return;
    }
  }

  Future<Expedition?> getExpedition(String id) async {
    try {
      DocumentSnapshot doc = await _expeditionCollection.doc(id).get();
      if (doc.exists) {
        return Expedition.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read expedition: ${e.toString()}');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllExpeditions() {
    return _expeditionCollection.snapshots();
  }

  Future<void> updateExpedition(String id, Expedition expedition) async {
    try {
      await _expeditionCollection.doc(id).update(expedition.toMap());
    } catch (e) {
      _logger.severe('Failed to update expedition: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteExpedition(String id) async {
    try {
      await _expeditionCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete expedition: ${e.toString()}');
      return;
    }
  }
}
