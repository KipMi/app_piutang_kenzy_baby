import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpeditionHomePage extends StatelessWidget {
  const ExpeditionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Home'),
      ),
      body: const Center(
        child: Column(
          children: [
            Row(
              children: [
                NavigationButton(
                    routeName: 'expedition-table',
                    buttonText: 'Expedition Table'),
                NavigationButton(
                    routeName: 'create-expedition',
                    buttonText: 'Create Expedition'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
