import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomerTablePage extends StatefulWidget {
  const CustomerTablePage({super.key});

  @override
  State<CustomerTablePage> createState() => _CustomerTablePageState();
}

class _CustomerTablePageState extends State<CustomerTablePage> {
  final _customerService =
      CustomerService(firestore: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Table'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _customerService.getAllCustomers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nama Toko')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [
                    for (final customer in snapshot.data!.docs)
                      DataRow(
                        cells: [
                          DataCell(Text(customer['storeName'])),
                          DataCell(Text(DateFormat('yyyy-MM-dd').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  customer['createdAt'])))),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    context.goNamed('customer-detail',
                                        pathParameters: {'id': customer.id});
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
                                          content: const Text(
                                              'Are you sure you want to delete this customer?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _customerService.deleteCustomer(
                                                    customer.id);
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
