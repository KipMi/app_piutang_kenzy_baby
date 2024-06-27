import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final int createdAt;
  final String address;
  final String categoryId;
  final String expeditionId;
  final int phoneNumber;
  final String storeName;

  Customer({
    this.id = '',
    required this.createdAt,
    required this.address,
    required this.categoryId,
    required this.expeditionId,
    required this.phoneNumber,
    required this.storeName,
  });

  // Function to convert a Customer into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'address': address,
      'categoryId': categoryId,
      'expeditionId': expeditionId,
      'phoneNumber': phoneNumber,
      'storeName': storeName,
    };
  }

  // Function to create a Customer from a map
  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      createdAt: map['createdAt'],
      address: map['address'],
      categoryId: map['categoryId'],
      expeditionId: map['expeditionId'],
      phoneNumber: map['phoneNumber'],
      storeName: map['storeName'],
    );
  }

  factory Customer.fromSnapshot(DocumentSnapshot snapshot) {
    return Customer.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
