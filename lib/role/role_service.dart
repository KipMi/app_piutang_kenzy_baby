import 'role_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class RoleService {
  final Logger _logger = Logger('RoleService');
  final FirebaseFirestore firestore;
  late final CollectionReference _roleCollection;

  RoleService({required this.firestore}) {
    _roleCollection = firestore.collection('roles');
  }

  Future<void> createRole(Role role) async {
    try {
      DocumentReference docRef = _roleCollection.doc();

      Role newRole = Role(
          id: docRef.id,
          createdAt: role.createdAt,
          roleName: role.roleName,
          status: role.status);

      await docRef.set(newRole.toMap());
    } catch (e) {
      _logger.severe('Failed to create role: ${e.toString()}');
      return;
    }
  }

  Future<Role?> getRole(String id) async {
    try {
      DocumentSnapshot doc = await _roleCollection.doc(id).get();
      if (doc.exists) {
        return Role.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('No data found for the given id');
      }
    } catch (e) {
      _logger.severe('Failed to read role');
      return null;
    }
  }

  Stream<QuerySnapshot> getAllRoles() {
    return _roleCollection.snapshots();
  }

  Future<void> updateRole(String id, Role role) async {
    try {
      await _roleCollection.doc(id).update(role.toMap());
    } catch (e) {
      _logger.severe('Failed to update role: ${e.toString()}');
      return;
    }
  }

  Future<void> deleteRole(String id) async {
    try {
      await _roleCollection.doc(id).delete();
    } catch (e) {
      _logger.severe('Failed to delete role: ${e.toString()}');
      return;
    }
  }
}
