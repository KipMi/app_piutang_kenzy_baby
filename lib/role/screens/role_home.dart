import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RoleHomePage extends StatelessWidget {
  const RoleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Home'),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              NavigationButton(
                  routeName: 'create-role', buttonText: 'Create Role'),
              NavigationButton(
                  routeName: 'role-table', buttonText: 'View Roles'),
            ],
          ),
        ],
      ),
    );
  }
}
