import 'package:app_piutang_kenzy_baby/expedition/expedition_model.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _createExpeditionKey = GlobalKey<FormState>();

class CreateExpeditionPage extends StatefulWidget {
  const CreateExpeditionPage({super.key});

  @override
  State<CreateExpeditionPage> createState() => _CreateExpeditionPageState();
}

class _CreateExpeditionPageState extends State<CreateExpeditionPage> {
  final TextEditingController _nameController = TextEditingController();
  String status = 'ACTIVE';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Expedition'),
      ),
      body: Form(
        key: _createExpeditionKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Expedition name cannot be empty' : null,
                decoration: const InputDecoration(
                    hintText: 'Expedition Name',
                    border: OutlineInputBorder(),
                    labelText: 'Expedition Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                    hintText: 'Status',
                    border: OutlineInputBorder(),
                    labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    child: Text('ACTIVE'),
                    value: 'ACTIVE',
                  ),
                  DropdownMenuItem(
                    child: Text('INACTIVE'),
                    value: 'INACTIVE',
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Create New Expedition'),
                        content: const Text(
                            'Are you sure you want to create this expedition?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_createExpeditionKey.currentState!.validate())
                                createExpedition();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text('Create Expedition'),
            )
          ],
        ),
      ),
    );
  }

  void createExpedition() async {
    late ExpeditionService expeditionService;
    late FirebaseFirestore firestore;

    firestore = FirebaseFirestore.instance;
    expeditionService = ExpeditionService(firestore: firestore);

    final name = _nameController.text;

    if (_createExpeditionKey.currentState!.validate()) {
      _nameController.clear();
      await expeditionService.createExpedition(
        Expedition(
          name: name,
          status: status,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
