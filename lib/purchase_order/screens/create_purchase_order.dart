import 'package:app_piutang_kenzy_baby/add_item/add_item_service.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_model.dart';
import 'package:app_piutang_kenzy_baby/customer/customer_service.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_notifier.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/purchase_order_model.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/purchase_order_service.dart';
import 'package:app_piutang_kenzy_baby/user/user_service.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreatePurchaseOrderPage extends ConsumerStatefulWidget {
  const CreatePurchaseOrderPage({super.key});

  @override
  ConsumerState<CreatePurchaseOrderPage> createState() =>
      _CreatePurchaseOrderPageState();
}

class _CreatePurchaseOrderPageState
    extends ConsumerState<CreatePurchaseOrderPage> {
  final CustomerService _customerService =
      CustomerService(firestore: FirebaseFirestore.instance);
  String? _customerName;
  String? _paymentType;

  @override
  Widget build(BuildContext context) {
    final addedItems = ref.watch(addedItemNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Purchase Order'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<Customer>(
                  asyncItems: (String items) async {
                    final data =
                        await _customerService.getAllCustomersAsFuture();
                    return data
                        .where((element) => element.storeName.contains(items))
                        .toList();
                  },
                  itemAsString: (Customer customer) => customer.storeName,
                  onChanged: (Customer? customer) {
                    _customerName = customer!.storeName;
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama Customer'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value: _paymentType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jenis Pembayaran',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'CASH',
                      child: Text('Cash'),
                    ),
                    DropdownMenuItem(
                      value: 'CICIL',
                      child: Text('Credit'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: ScreenSize.width,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed('add-item');
                  },
                  child: const Text('Add Item'),
                ),
              ),
              // Add item list here
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Artikel')),
                      DataColumn(label: Text('Nama Barang')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Harga')),
                      DataColumn(label: Text('Action'))
                    ],
                    rows: addedItems.map((item) {
                      if (addedItems.isEmpty) {
                        return const DataRow(cells: [
                          DataCell(Text('No data')),
                          DataCell(Text('No Data')),
                          DataCell(Text('No Data')),
                          DataCell(Text('No Data')),
                          DataCell(Text('No Data'))
                        ]);
                      }
                      return DataRow(
                        cells: [
                          DataCell(Text(item.item.articleCode)),
                          DataCell(Text(item.item.itemName)),
                          DataCell(Text(item.quantity.toString())),
                          DataCell(Text(item.sumHarga.toString())),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .read(addedItemNotifierProvider.notifier)
                                  .removeItems(item);
                            },
                          ))
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Price: \$${addedItems.map((item) => item.sumHarga).fold(0, (a, b) => a + b)}',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Create Purchase Order'),
                        content: const Text(
                            'Are you sure you want to create this purchase order?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _createPO();
                              _customerName = null;
                              _paymentType = null;
                              ref
                                  .read(addedItemNotifierProvider.notifier)
                                  .clear();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Purchase Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPO() async {
    final PurchaseOrderService _purchaseOrderService =
        PurchaseOrderService(firestore: FirebaseFirestore.instance);
    final AddItemService _addItemService =
        AddItemService(firestore: FirebaseFirestore.instance);
    final UserService _userService =
        UserService(firestore: FirebaseFirestore.instance);

    final addedItems = ref.watch(addedItemNotifierProvider);

    final int price =
        addedItems.map((item) => item.sumHarga).fold(0, (a, b) => a + b);

    final Map<String, int> items = Map.fromEntries(
        addedItems.map((item) => MapEntry(item.item.id, item.quantity)));

    String itemId = await _addItemService.addItem(items);
    String? salesId = await _userService.getCurrentUserRoleId();

    final PurchaseOrder purchaseOrder = PurchaseOrder(
      poDate: DateTime.now().millisecondsSinceEpoch,
      customerName: _customerName!,
      salesId: salesId!,
      itemId: itemId,
      price: price,
      totalPrice: price,
      status: 'PENDING',
      payment: _paymentType!,
    );

    await _purchaseOrderService.createPurchaseOrder(purchaseOrder);
  }
}
