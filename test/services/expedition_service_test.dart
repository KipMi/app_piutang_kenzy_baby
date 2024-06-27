import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ExpeditionService expeditionService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    expeditionService = ExpeditionService(firestore: fakeFirestore);
  });

  test('getExpedition should return the correct expedition', () async {
    // Arrange
    final expeditionId = '123';
    final expeditionData = {
      'id': expeditionId,
      'createdAt': DateTime.now(),
      'name': 'Test Expedition',
      'status': 'Pending',
    };
    fakeFirestore
        .collection('expeditions')
        .doc(expeditionId)
        .set(expeditionData);

    // Act
    final expedition = await expeditionService.getExpedition(expeditionId);

    // Assert
    expect(expedition, isNotNull);
    expect(expedition!.id, expeditionId);
    expect(expedition.createdAt, expeditionData['createdAt']);
    expect(expedition.name, expeditionData['name']);
    expect(expedition.status, expeditionData['status']);
  });

  test('getExpedition should return null if no data found', () async {
    // Arrange
    final expeditionId = '123';

    // Act
    final expedition = await expeditionService.getExpedition(expeditionId);

    // Assert
    expect(expedition, isNull);
  });
}
