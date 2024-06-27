import 'package:app_piutang_kenzy_baby/item/item_model.dart';

class AddedItem {
  final Item item;
  final int quantity;
  final int sumHarga;

  AddedItem(
      {required this.item, required this.quantity, required this.sumHarga});

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantity': quantity,
      'sumHarga': sumHarga,
    };
  }

  static AddedItem fromMap(Map<String, dynamic> map) {
    return AddedItem(
      item: Item.fromMap(map['item']),
      quantity: map['quantity'],
      sumHarga: map['sumHarga'],
    );
  }
}
