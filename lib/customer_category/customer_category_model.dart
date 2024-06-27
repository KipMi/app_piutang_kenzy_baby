class CustomerCategory {
  final String id;
  final int createdAt;
  final String name;
  final String status;

  CustomerCategory({
    this.id = '',
    required this.createdAt,
    required this.name,
    required this.status,
  });

  // Function to convert a CustomerCategory into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'status': status,
    };
  }

  // Function to create a CustomerCategory from a map
  static CustomerCategory fromMap(Map<String, dynamic> map) {
    return CustomerCategory(
      id: map['id'],
      createdAt: map['createdAt'],
      name: map['name'],
      status: map['status'],
    );
  }
}
