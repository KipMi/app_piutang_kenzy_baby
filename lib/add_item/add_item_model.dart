import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_model.dart';

class AddItem {
  final String id;
  final Map<String, int> selectedItems;

  AddItem({required this.id, required this.selectedItems});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': selectedItems,
    };
  }

  static AddItem fromMap(Map<String, dynamic> map) {
    return AddItem(
      id: map['id'],
      selectedItems: map['items'],
    );
  }
}
