import 'package:app_piutang_kenzy_baby/user/user_service.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService _userService =
        UserService(firestore: FirebaseFirestore.instance);
    final String? uid = FirebaseAuth.instance.currentUser!.uid;
    String? role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kenzy Baby Management'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            FutureBuilder(
              future: _userService.getCurrentUserRoleName(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  role = snapshot.data;
                  if (role != 'Admin') {
                    return const SizedBox.shrink();
                  } else if (role == 'Admin') {
                    return Column(
                      children: [
                        ListTile(
                          title: const Text('User'),
                          onTap: () {
                            context.goNamed('user-home');
                          },
                        ),
                        ListTile(
                          title: const Text('Role'),
                          onTap: () {
                            context.goNamed('role-home');
                          },
                        ),
                      ],
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
            ListTile(
              title: const Text('Purchase Order'),
              onTap: () {
                context.goNamed('purchase-order-home');
              },
            ),
            ListTile(
              title: const Text('Customer'),
              onTap: () {
                context.goNamed('customer-home');
              },
            ),
            ListTile(
              title: const Text('Customer Category'),
              onTap: () {
                context.goNamed('customer-category-home');
              },
            ),
            ListTile(
              title: const Text('Item'),
              onTap: () {
                context.goNamed('item-home');
              },
            ),
            ListTile(
              title: const Text('Expedition'),
              onTap: () {
                context.goNamed('expedition-home');
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.goNamed('login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/logo_PNG.png',
          width: ScreenSize.width! * 0.5,
        ),
      ),
    );
  }
}
