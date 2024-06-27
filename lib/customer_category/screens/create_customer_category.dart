import 'package:app_piutang_kenzy_baby/customer_category/customer_category_model.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _createCustomerCategoryKey = GlobalKey<FormState>();

class CreateCustomerCategoryPage extends StatefulWidget {
  const CreateCustomerCategoryPage({super.key});

  @override
  State<CreateCustomerCategoryPage> createState() =>
      _CreateCustomerCategoryPageState();
}

class _CreateCustomerCategoryPageState
    extends State<CreateCustomerCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  String _customerCategoryStatus = 'ACTIVE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Customer Category'),
      ),
      body: Form(
        key: _createCustomerCategoryKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _categoryNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Category name cannot be empty' : null,
                decoration: const InputDecoration(
                    labelText: 'Category Name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Category Status', border: OutlineInputBorder()),
                value: _customerCategoryStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _customerCategoryStatus = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'ACTIVE',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'INACTIVE',
                    child: Text('Inactive'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Create Customer Category'),
                        content: const Text(
                            'Are you sure you want to create this customer category?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              createCustomerCategory();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Create'),
                          )
                        ],
                      );
                    });
              },
              child: const Text('Create'),
            )
          ],
        ),
      ),
    );
  }

  void createCustomerCategory() {
    final CustomerCategoryService customerCategoryService =
        CustomerCategoryService(firestore: FirebaseFirestore.instance);

    if (_createCustomerCategoryKey.currentState!.validate()) {
      final String categoryName = _categoryNameController.text;
      final String status = _customerCategoryStatus;

      _categoryNameController.clear();
      // Call the service to create the customer category
      customerCategoryService.createCustomerCategory(
        CustomerCategory(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          name: categoryName,
          status: status,
        ),
      );
    }
  }
}
