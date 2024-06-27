import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_model.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _createCustomerKey = GlobalKey<FormState>();

class CreateCustomerPage extends StatefulWidget {
  const CreateCustomerPage({super.key});

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final CustomerCategoryService _customerCategoryService =
      CustomerCategoryService(firestore: FirebaseFirestore.instance);
  final ExpeditionService _expeditionService =
      ExpeditionService(firestore: FirebaseFirestore.instance);

  String? _categoryId;
  String? _expeditionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Customer'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _createCustomerKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _storeNameController,
                validator: (value) =>
                    value!.isEmpty ? 'Store name cannot be empty' : null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Store Name',
                    labelText: 'Store Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _phoneNumberController,
                validator: (value) =>
                    value!.isEmpty ? 'Phone number cannot be empty' : null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '08123456789',
                    labelText: 'Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _addressController,
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Address cannot be empty' : null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Jl. Test 123',
                    labelText: 'Customer address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _customerCategoryService.getAllCustomerCategories(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    List<DropdownMenuItem<String>> categoryItems = [];
                    for (var category in snapshot.data!.docs) {
                      categoryItems.add(DropdownMenuItem(
                        value: category.id,
                        child: Text(category['name']),
                      ));
                    }
                    if (categoryItems.isEmpty) {
                      return const Text('No categories found');
                    } else {
                      return DropdownButtonFormField<String>(
                        value: _categoryId,
                        decoration: const InputDecoration(
                            hintText: 'Category',
                            border: OutlineInputBorder(),
                            labelText: 'Category'),
                        items: categoryItems,
                        onChanged: (value) {
                          setState(() {
                            _categoryId = value!;
                          });
                        },
                      );
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _expeditionService.getAllExpeditions(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    List<DropdownMenuItem<String>> expeditionItems = [];
                    for (var expedition in snapshot.data!.docs) {
                      expeditionItems.add(DropdownMenuItem(
                        value: expedition.id,
                        child: Text(expedition['name']),
                      ));
                    }
                    if (expeditionItems.isEmpty) {
                      return const Text('No expeditions found');
                    } else {
                      return DropdownButtonFormField<String>(
                        value: _expeditionId,
                        validator: (value) =>
                            value == null ? 'Expedition cannot be empty' : null,
                        decoration: const InputDecoration(
                            hintText: 'Expedition',
                            border: OutlineInputBorder(),
                            labelText: 'Expedition'),
                        items: expeditionItems,
                        onChanged: (value) {
                          setState(() {
                            _expeditionId = value!;
                          });
                        },
                      );
                    }
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                createCustomer();
              },
              child: const Text('Create Customer'),
            )
          ],
        ),
      )),
    );
  }

  void createCustomer() async {
    late CustomerService customerService;
    late FirebaseFirestore firestore;

    if (_createCustomerKey.currentState!.validate()) {
      firestore = FirebaseFirestore.instance;
      customerService = CustomerService(firestore: firestore);

      String address = _addressController.text;
      String storeName = _storeNameController.text;
      int phoneNumber = int.parse(_phoneNumberController.text);
      String? categoryId = _categoryId;
      String expeditionId = _expeditionId!;

      _addressController.clear();
      _storeNameController.clear();
      _phoneNumberController.clear();

      await customerService.createCustomer(
        Customer(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          address: address,
          categoryId: categoryId!,
          expeditionId: expeditionId,
          phoneNumber: phoneNumber,
          storeName: storeName,
        ),
      );
    }
  }
}
