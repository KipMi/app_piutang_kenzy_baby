import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
      ),
      body: const Center(
        child: Column(
          children: [
            Row(
              children: [
                NavigationButton(
                    routeName: 'user-table', buttonText: 'Users Table'),
                NavigationButton(
                    routeName: 'create-user', buttonText: 'Create User'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
