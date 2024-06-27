import 'package:app_piutang_kenzy_baby/role/role_service.dart';
import 'package:app_piutang_kenzy_baby/user/user_auth/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:app_piutang_kenzy_baby/user/user_model.dart';
import 'package:app_piutang_kenzy_baby/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _createUserKey = GlobalKey<FormState>();

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _roleService = RoleService(firestore: FirebaseFirestore.instance);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  String? roleValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New User'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _createUserKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _usernameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Username cannot be empty' : null,
                  decoration: const InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                      labelText: 'Username'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: _roleService.getAllRoles(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        List<DropdownMenuItem<String>> roleItems = [];
                        for (var role in snapshot.data!.docs) {
                          roleItems.add(DropdownMenuItem(
                            value: role.id,
                            child: Text(role['roleName']),
                          ));
                        }
                        if (roleItems.isEmpty) {
                          return const Text('No roles found');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: roleValue,
                            decoration: const InputDecoration(
                                hintText: 'Role',
                                border: OutlineInputBorder(),
                                labelText: 'Role'),
                            items: roleItems,
                            onChanged: (value) {
                              setState(() {
                                roleValue = value!;
                              });
                            },
                          );
                        }
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? 'E-Mail cannot be empty' : null,
                  decoration: const InputDecoration(
                      hintText: 'E-Mail',
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) => value!.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      labelText: 'Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordConfirmController,
                  validator: (value) => value != _passwordController.text
                      ? 'Password mismatch'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  controller: _addressController,
                  validator: (value) =>
                      value!.isEmpty ? 'User address cannot be empty' : null,
                  decoration: const InputDecoration(
                      hintText: 'User Address',
                      border: OutlineInputBorder(),
                      labelText: 'User address'),
                ),
              ),
              ElevatedButton(
                  onPressed: signUp, child: const Text('Create User'))
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    late UserService userService;
    late FirebaseFirestore firestore;

    if (!_createUserKey.currentState!.validate()) {
      return;
    }

    firestore = FirebaseFirestore.instance;
    userService = UserService(firestore: firestore);

    String email = _emailController.text;
    String password = _passwordController.text;
    String userAddress = _addressController.text;
    String username = _usernameController.text;
    String? roleId = roleValue;

    _emailController.clear();
    _passwordController.clear();
    _passwordConfirmController.clear();
    _addressController.clear();
    _usernameController.clear();

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    UserData newUser = UserData(
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        email: email,
        password: password,
        roleId: roleId!,
        userAddress: userAddress,
        username: username);

    await userService.createUser(newUser, user!.uid);
    final snapshot = await firestore.collection('users').get();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Created'),
          content: Text(
              'User created successfully. Total users: ${snapshot.docs.length}'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }
}
