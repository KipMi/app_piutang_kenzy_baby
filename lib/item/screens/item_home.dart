import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/material.dart';

class ItemHomePage extends StatelessWidget {
  const ItemHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Home'),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              NavigationButton(
                  routeName: 'item-table', buttonText: 'Items Table'),
              NavigationButton(
                  routeName: 'create-item', buttonText: 'Create Item'),
            ],
          ),
        ],
      ),
    );
  }
}
