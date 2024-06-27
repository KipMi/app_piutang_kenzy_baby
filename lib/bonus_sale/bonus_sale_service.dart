import 'bonus_sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class BonusSaleService {
  final Logger _logger = Logger('BonusSaleService');
  final FirebaseFirestore firestore;
  late final CollectionReference _bonusSaleCollection;

  BonusSaleService({required this.firestore}) {
    _bonusSaleCollection = firestore.collection('bonus_sales');
  }

  Future<void> createBonusSale(BonusSale bonusSale) async {
    try {
      DocumentReference docRef = _bonusSaleCollection.doc();

      BonusSale newBonusSale = BonusSale(
          salesId: docRef.id,
          period: bonusSale.period,
          penjualan: bonusSale.penjualan,
          payment: bonusSale.payment,
          totalCommission: bonusSale.totalCommission,
          details: bonusSale.details);

      await docRef.set(newBonusSale.toMap());
    } catch (e) {
      _logger.severe('Failed to create bonus sale: ${e.toString()}');
      return;
    }
  }
}
