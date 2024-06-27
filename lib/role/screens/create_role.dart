import 'package:app_piutang_kenzy_baby/role/role_model.dart';
import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _createRoleKey = GlobalKey<FormState>();

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final TextEditingController _roleNameController = TextEditingController();
  String _roleStatus = 'ACTIVE';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Role'),
      ),
      body: Form(
        key: _createRoleKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _roleNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Role name cannot be empty' : null,
                decoration: const InputDecoration(
                    labelText: 'Role Name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Role Status', border: OutlineInputBorder()),
                value: _roleStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _roleStatus = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'ACTIVE',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'INACTIVE',
                    child: Text('Inactive'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                createRole();
              },
              child: const Text('Save Role'),
            )
          ],
        ),
      ),
    );
  }

  void createRole() async {
    final RoleService _roleService =
        RoleService(firestore: FirebaseFirestore.instance);
    if (_createRoleKey.currentState!.validate()) {
      final String roleName = _roleNameController.text;
      final String status = _roleStatus;

      _roleNameController.clear();

      await _roleService.createRole(
        Role(
            createdAt: DateTime.now().millisecondsSinceEpoch,
            roleName: roleName,
            status: status),
      );
    }
  }
}
