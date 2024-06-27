import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/item/item_service.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_model.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_notifier.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemPage extends ConsumerStatefulWidget {
  const AddItemPage({super.key});

  @override
  ConsumerState<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  final _itemService = ItemService(firestore: FirebaseFirestore.instance);
  final TextEditingController _quantityController = TextEditingController();
  String _searchTerm = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _itemService.getAllItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            final items = snapshot.data!.docs
                .where((element) =>
                    element['articleCode']
                        .toString()
                        .toLowerCase()
                        .contains(_searchTerm.toLowerCase()) ||
                    element['itemName']
                        .toString()
                        .toLowerCase()
                        .contains(_searchTerm.toLowerCase()))
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    SizedBox(
                      width: ScreenSize.width,
                      child: TextField(
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          setState(() {
                            _searchTerm = value;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Search'),
                      ),
                    ),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Artikel')),
                        DataColumn(label: Text('Nama Barang')),
                        DataColumn(label: Text('Harga')),
                        DataColumn(label: Text('Stok Barang')),
                        DataColumn(label: Text('Action'))
                      ],
                      rows: items
                          .map((item) => DataRow(
                                cells: [
                                  DataCell(Text(item['articleCode'])),
                                  DataCell(Text(item['itemName'])),
                                  DataCell(Text(item['price'].toString())),
                                  DataCell(Text(item['totalStock'].toString())),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        // Add item to the purchase order
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Select Quantity'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        _quantityController,
                                                    onChanged: (value) {
                                                      // Update the quantity
                                                      // You can store the quantity in a variable or pass it to a callback function
                                                      _quantityController.text =
                                                          value;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Quantity'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Add item to the purchase order with the selected quantity
                                                      // You can pass the quantity to the addItems function or use it directly
                                                      int quantity = int.parse(
                                                          _quantityController
                                                              .text);
                                                      int totalStock =
                                                          item['totalStock'];
                                                      int price = item['price'];
                                                      if (quantity >
                                                          totalStock) {
                                                        quantity = totalStock;
                                                      }
                                                      ref
                                                          .read(
                                                              addedItemNotifierProvider
                                                                  .notifier)
                                                          .addItems(
                                                            AddedItem(
                                                              item: Item(
                                                                id: item.id,
                                                                articleCode: item[
                                                                    'articleCode'],
                                                                itemName: item[
                                                                    'itemName'],
                                                                price: item[
                                                                    'price'],
                                                                totalStock: item[
                                                                    'totalStock'],
                                                              ),
                                                              quantity:
                                                                  quantity,
                                                              sumHarga: price *
                                                                  quantity,
                                                            ),
                                                          );
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Add'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
