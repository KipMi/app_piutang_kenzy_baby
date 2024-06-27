class Item {
  final String id; // input manual
  final String articleCode;
  final String itemName;
  final int price;
  final int totalStock;

  Item(
      {this.id = '',
      required this.articleCode,
      required this.itemName,
      required this.price,
      required this.totalStock});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'articleCode': articleCode,
      'itemName': itemName,
      'price': price,
      'totalStock': totalStock,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
        id: map['id'],
        articleCode: map['articleCode'],
        itemName: map['itemName'],
        price: map['price'],
        totalStock: map['totalStock']);
  }
}
