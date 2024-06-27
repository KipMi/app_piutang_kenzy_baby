import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RoleTablePage extends StatefulWidget {
  const RoleTablePage({super.key});

  @override
  State<RoleTablePage> createState() => _RoleTablePageState();
}

class _RoleTablePageState extends State<RoleTablePage> {
  final _roleService = RoleService(firestore: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Table'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _roleService.getAllRoles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Role Name')),
                    DataColumn(label: Text('Role Status')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    for (final role in snapshot.data!.docs)
                      DataRow(
                        cells: [
                          DataCell(Text(role['roleName'])),
                          DataCell(Text(role['status'])),
                          DataCell(Text(DateFormat('yyyy-MM-dd').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  role['createdAt'])))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.goNamed('role-detail',
                                      pathParameters: {'id': role.id});
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Role'),
                                        content: Text(
                                            'Are you sure you want to delete ${role['roleName']}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _roleService.deleteRole(role.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ))
                        ],
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
