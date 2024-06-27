import 'package:app_piutang_kenzy_baby/role/role_model.dart';
import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:app_piutang_kenzy_baby/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserTablePage extends StatefulWidget {
  const UserTablePage({super.key});

  @override
  State<UserTablePage> createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  final _userService = UserService(firestore: FirebaseFirestore.instance);
  final _roleService = RoleService(firestore: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Table'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    for (final user in snapshot.data!.docs)
                      DataRow(cells: [
                        DataCell(Text(user['username'])),
                        DataCell(
                          FutureBuilder<Role?>(
                            future: _roleService.getRole(user['roleId']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.roleName);
                              }
                              return const Text('Loading...');
                            },
                          ),
                        ),
                        DataCell(Text(DateFormat('yyyy-MM-dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                user['createdAt'])))),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.goNamed('user-detail',
                                    pathParameters: {'id': user.id});
                              },
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete User'),
                                      content: Text(
                                          'Are you sure you want to delete ${user['username']}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _userService.deleteUser(user.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ))
                      ])
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
