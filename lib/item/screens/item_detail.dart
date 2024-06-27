import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/item/item_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemDetailPage extends StatelessWidget {
  final String? id;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final ItemService _itemService;
  ItemDetailPage({super.key, this.id}) {
    _itemService = ItemService(firestore: firestore);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Item?>(
        future: _itemService.getItem(id!),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('Barang: ${data!.itemName}'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ListTile(
                    title: const Text('ID'),
                    subtitle: Text(data.id),
                  ),
                  ListTile(
                    title: const Text('Kode Artikel'),
                    subtitle: Text(data.articleCode),
                  ),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(data.itemName),
                  ),
                  ListTile(
                    title: const Text('Price'),
                    subtitle: Text(data.price.toString()),
                  ),
                  ListTile(
                    title: const Text('Stock'),
                    subtitle: Text(data.totalStock.toString()),
                  ),
                  ListTile(
                    title: const Text('Actions'),
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.goNamed('item-edit', pathParameters: {
                              'id': data.id,
                              'itemId': data.id
                            });
                          },
                          child: const Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Item'),
                                  content: Text(
                                      'Are you sure you want to delete ${data.itemName}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _itemService.deleteItem(data.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Error'),
                ),
                body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Loading data'),
                ),
                body: Center(child: Text('Loading data... $id')));
          }
        });
  }
}
