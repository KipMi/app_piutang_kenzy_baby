import 'package:app_piutang_kenzy_baby/purchase_order/purchase_order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseOrderDetail extends StatelessWidget {
  final String? id;
  late final PurchaseOrderService _purchaseOrderService;
  PurchaseOrderDetail({super.key, required this.id}) {
    _purchaseOrderService =
        PurchaseOrderService(firestore: FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _purchaseOrderService
            .getPurchaseOrder('75e8afa012b0101b8f07bb967081be14'),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text('Purchase Order ${data!.id}'),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    ListTile(
                      title: const Text('ID'),
                      subtitle: Text(data.id),
                    ),
                    ListTile(
                      title: const Text('Nama Customer'),
                      subtitle: Text(data.customerName),
                    ),
                    ListTile(
                      title: const Text('Nama Sales'),
                      subtitle: Text(data.salesId),
                    ),
                    ListTile(
                      title: const Text('Status'),
                      subtitle: Text(data.status),
                    ),
                  ],
                ));
          } else if (snapshot.hasError) {
            final data = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text(data?.id ?? 'Purchase Order'),
                ),
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
