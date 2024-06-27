import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseOrder {
  final String id;
  final int poDate;
  final String customerName;
  final String salesId;
  final String itemId;
  final int price;
  final int totalPrice;
  final double discount;
  final String status;
  final String payment;

  PurchaseOrder({
    this.id = '',
    required this.poDate,
    required this.customerName,
    required this.salesId,
    required this.itemId,
    required this.price,
    required this.totalPrice,
    this.discount = 0.0,
    required this.status,
    required this.payment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poDate': poDate,
      'customerName': customerName,
      'salesId': salesId,
      'itemId': itemId,
      'price': price,
      'totalPrice': totalPrice,
      'discount': discount,
      'status': status,
      'payment': payment,
    };
  }

  static PurchaseOrder fromMap(Map<String, dynamic> map) {
    return PurchaseOrder(
        id: map['id'],
        poDate: map['poDate'],
        customerName: map['customerName'],
        salesId: map['salesId'],
        itemId: map['itemId'],
        price: map['price'],
        totalPrice: map['totalPrice'],
        discount: map['discount'],
        status: map['status'],
        payment: map['payment']);
  }

  factory PurchaseOrder.fromSnapshot(DocumentSnapshot snapshot) {
    return PurchaseOrder.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
