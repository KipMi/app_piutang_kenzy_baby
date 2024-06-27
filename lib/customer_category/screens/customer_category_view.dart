import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomerCategoryTablePage extends StatefulWidget {
  const CustomerCategoryTablePage({super.key});

  @override
  State<CustomerCategoryTablePage> createState() =>
      _CustomerCategoryTablePageState();
}

class _CustomerCategoryTablePageState extends State<CustomerCategoryTablePage> {
  final _customerCategoryService =
      CustomerCategoryService(firestore: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Category Table'),
      ),
      body: StreamBuilder(
        stream: _customerCategoryService.getAllCustomerCategories(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Category Name')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [
                    for (final customerCategory in snapshot.data!.docs)
                      DataRow(
                        cells: [
                          DataCell(Text(customerCategory['name'])),
                          DataCell(Text(DateFormat('yyyy-MM-dd').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  customerCategory['createdAt'])))),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    context.goNamed('customer-category-detail',
                                        pathParameters: {
                                          'id': customerCategory.id
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
                                          title: const Text(
                                              'Delete Customer Category'),
                                          content: const Text(
                                              'Are you sure you want to delete this customer category?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _customerCategoryService
                                                    .deleteCustomerCategory(
                                                        customerCategory.id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
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
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
