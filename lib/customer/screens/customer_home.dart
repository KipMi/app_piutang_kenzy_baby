import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Home'),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              NavigationButton(
                  routeName: 'customer-table', buttonText: 'Customers Table'),
              NavigationButton(
                  routeName: 'create-customer', buttonText: 'Create Customer'),
            ],
          ),
        ],
      ),
    );
  }
}
