class UserData {
  final String id;
  final int createdAt;
  final String email;
  final String
      password; // Consider not storing passwords directly for security reasons
  final String roleId;
  final String userAddress;
  final String username;

  UserData(
      {this.id = '',
      required this.createdAt,
      required this.email,
      required this.password,
      required this.roleId,
      required this.userAddress,
      required this.username});

  // Function to convert a User into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'email': email,
      'password': password,
      'roleId': roleId,
      'userAddress': userAddress,
      'username': username
    };
  }

  // Function to create a User from a map
  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
        id: map['id'],
        createdAt: map['createdAt'],
        email: map['email'],
        password: map['password'],
        roleId: map['roleId'],
        userAddress: map['userAddress'],
        username: map['username']);
  }
}
