import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_model.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_model.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomerDetailPage extends StatelessWidget {
  final String? id;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CustomerService _customerService;
  late final CustomerCategoryService _categoryService;
  late final ExpeditionService _expeditionService;
  CustomerDetailPage({super.key, this.id}) {
    _customerService = CustomerService(firestore: firestore);
    _categoryService = CustomerCategoryService(firestore: firestore);
    _expeditionService = ExpeditionService(firestore: firestore);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Customer?>(
      future: _customerService.getCustomer(id!),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text('Toko ${data!.storeName}'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ListTile(
                    title: const Text('ID'),
                    subtitle: Text(data.id),
                  ),
                  ListTile(
                    title: const Text('Nama Toko'),
                    subtitle: Text(data.storeName),
                  ),
                  ListTile(
                    title: const Text('Category'),
                    subtitle: FutureBuilder<CustomerCategory?>(
                      future:
                          _categoryService.getCustomerCategory(data.categoryId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.name);
                        }
                        return const Text('Loading...');
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('ExpeditionID'),
                    subtitle: Text(data.expeditionId),
                  ),
                  ListTile(
                    title: const Text('Expedition'),
                    subtitle: FutureBuilder<Expedition?>(
                      future:
                          _expeditionService.getExpedition(data.expeditionId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.name);
                        }
                        return const Text('Loading...');
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Alamat'),
                    subtitle: Text(data.address),
                  ),
                  ListTile(
                    title: const Text('Nomor Telepon'),
                    subtitle: Text(data.phoneNumber.toString()),
                  ),
                  ListTile(
                    title: const Text('Created At'),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(
                        DateTime.fromMillisecondsSinceEpoch(data.createdAt))),
                  ),
                  ListTile(
                    title: const Text('Actions'),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.goNamed('customer-edit', pathParameters: {
                              'customerId': data.id,
                              'id': data.id
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Customer'),
                                  content: Text(
                                      'Are you sure you want to delete ${data.storeName}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _customerService
                                            .deleteCustomer(data.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error occurred: ${snapshot.error}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
