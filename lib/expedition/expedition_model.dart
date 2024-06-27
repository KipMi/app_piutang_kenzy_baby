class Expedition {
  final String id;
  final int createdAt;
  final String name;
  final String status;

  Expedition({
    this.id = '',
    required this.createdAt,
    required this.name,
    required this.status,
  });

  // Function to convert an Expedition into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'status': status,
    };
  }

  // Function to create an Expedition from a map
  static Expedition fromMap(Map<String, dynamic> map) {
    return Expedition(
      id: map['id'],
      createdAt: map['createdAt'],
      name: map['name'],
      status: map['status'],
    );
  }
}
