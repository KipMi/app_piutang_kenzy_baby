import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderHome extends StatelessWidget {
  const PurchaseOrderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order Home'),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              NavigationButton(
                  routeName: 'purchase-order-view',
                  buttonText: 'Purchase Order Table'),
              NavigationButton(
                  routeName: 'create-purchase-order',
                  buttonText: 'Create Purchase Order'),
            ],
          ),
        ],
      ),
    );
  }
}
