import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCustomerPage extends StatefulWidget {
  final String? customerId;

  const EditCustomerPage({super.key, required this.customerId});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  // Add your state variables and methods here
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ExpeditionService _expeditionService =
      ExpeditionService(firestore: FirebaseFirestore.instance);
  final CustomerCategoryService _customerCategoryService =
      CustomerCategoryService(firestore: FirebaseFirestore.instance);
  String? _categoryId;
  String? _expeditionId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _storeNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Customer Name',
                      labelText: 'Store Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Phone number',
                      labelText: 'Phone number'),
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
                        return const Text('No category found');
                      } else {
                        return DropdownButtonFormField<String>(
                          value: _categoryId,
                          decoration: const InputDecoration(
                              hintText: 'Category',
                              border: OutlineInputBorder(),
                              labelText: 'Category'),
                          items: categoryItems,
                          onChanged: (String? value) {
                            setState(() {
                              _categoryId = value!;
                            });
                          },
                        );
                      }
                    }
                    ;
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
                        return const Text('No expedition found');
                      } else {
                        return DropdownButtonFormField<String>(
                          value: _expeditionId,
                          decoration: const InputDecoration(
                              hintText: 'Expedition',
                              border: OutlineInputBorder(),
                              labelText: 'Expedition'),
                          items: expeditionItems,
                          onChanged: (String? value) {
                            setState(() {
                              _expeditionId = value!;
                            });
                          },
                        );
                      }
                    }
                    ;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Address',
                      labelText: 'Address'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    editCustomer();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editCustomer() async {
    // Add your code here

    final CustomerService _customerService =
        CustomerService(firestore: FirebaseFirestore.instance);
    final storeName = _storeNameController.text;
    final phoneNumber = int.tryParse(_phoneNumberController.text);
    final address = _addressController.text;
    final category = _categoryId;
    final expedition = _expeditionId;

    final Customer updatedCustomer = Customer(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: widget.customerId!,
        address: address,
        categoryId: category!,
        expeditionId: expedition!,
        phoneNumber: phoneNumber!,
        storeName: storeName);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Customer'),
            content: const Text('Are you sure you want to edit this customer?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  _storeNameController.clear();
                  _phoneNumberController.clear();
                  _addressController.clear();
                  await _customerService.updateCustomer(
                      widget.customerId!, updatedCustomer);
                  Navigator.of(context).pop();
                },
                child: const Text('Edit'),
              )
            ],
          );
        });
  }
}
