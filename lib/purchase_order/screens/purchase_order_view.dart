import 'package:app_piutang_kenzy_baby/purchase_order/purchase_order_service.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderViewPage extends StatefulWidget {
  const PurchaseOrderViewPage({super.key});

  @override
  State<PurchaseOrderViewPage> createState() => _PurchaseOrderViewPageState();
}

class _PurchaseOrderViewPageState extends State<PurchaseOrderViewPage> {
  final PurchaseOrderService _purchaseOrderService =
      PurchaseOrderService(firestore: FirebaseFirestore.instance);
  String _searchTerm = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order View'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: _purchaseOrderService.getAllPurchaseOrders(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final purchaseOrders = snapshot.data!.docs
                    .where((element) => element['customerName']
                        .toString()
                        .toLowerCase()
                        .contains(_searchTerm.toLowerCase()))
                    .toList();
                return Column(
                  children: [
                    SizedBox(
                      width: ScreenSize.width,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchTerm = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search by customer name',
                        ),
                      ),
                    ),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('PO_ID')),
                        DataColumn(label: Text('Nama Customer')),
                        DataColumn(label: Text('Nama Sales')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Tanggal Pembuatan')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: purchaseOrders
                          .map(
                            (e) => DataRow(cells: [
                              DataCell(Text(e['id'])),
                              DataCell(Text(e['customerName'])),
                              DataCell(Text(e['salesId'])),
                              DataCell(Text(e['status'])),
                              DataCell(Text(e['poDate'].toString())),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    context.goNamed('purchase-order-detail',
                                        pathParameters: {'id': e.id});
                                  },
                                  child: const Text('View'),
                                ),
                              )
                            ]),
                          )
                          .toList(),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
