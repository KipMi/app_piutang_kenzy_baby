import 'package:app_piutang_kenzy_baby/role/role_model.dart';
import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:app_piutang_kenzy_baby/user/user_model.dart';
import 'package:app_piutang_kenzy_baby/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetailPage extends StatelessWidget {
  final String? id;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final UserService _userService;
  late final RoleService _roleService;
  UserDetailPage({super.key, this.id}) {
    _userService = UserService(firestore: firestore);
    _roleService = RoleService(firestore: firestore);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
        future: _userService.getUser(id!),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text('User ${data!.username}'),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    ListTile(
                      title: const Text('ID'),
                      subtitle: Text(data.id),
                    ),
                    ListTile(
                      title: const Text('Username'),
                      subtitle: Text(data.username),
                    ),
                    ListTile(
                      title: const Text('Role'),
                      subtitle: FutureBuilder<Role?>(
                        future: _roleService.getRole(data.roleId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.roleName);
                          }
                          return const Text('Loading...');
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Address'),
                      subtitle: Text(data.userAddress),
                    ),
                    ListTile(
                      title: const Text('Created At'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(
                          DateTime.fromMillisecondsSinceEpoch(data.createdAt))),
                    ),
                    ListTile(
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, 'edit-user',
                              //     arguments: data);
                            },
                            child: const Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Delete'),
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
