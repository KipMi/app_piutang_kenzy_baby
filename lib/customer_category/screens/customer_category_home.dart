import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/material.dart';

class CustomerCategoryHomePage extends StatelessWidget {
  const CustomerCategoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Category Home'),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              NavigationButton(
                  routeName: 'create-customer-category',
                  buttonText: 'Create Customer Category'),
              NavigationButton(
                  routeName: 'customer-category-table',
                  buttonText: 'View Customer Categories'),
            ],
          ),
        ],
      ),
    );
  }
}
