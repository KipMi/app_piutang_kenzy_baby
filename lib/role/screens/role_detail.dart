import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RoleDetailPage extends StatelessWidget {
  final String? id;
  late final RoleService _roleService;
  RoleDetailPage({super.key, this.id}) {
    _roleService = RoleService(firestore: FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _roleService.getRole(id!),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text('Role ${data!.roleName}'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ListTile(
                    title: const Text('ID'),
                    subtitle: Text(data.id),
                  ),
                  ListTile(
                    title: const Text('Role Name'),
                    subtitle: Text(data.roleName),
                  ),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(data.status),
                  ),
                ],
              ));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
