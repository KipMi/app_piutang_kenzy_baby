import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/item/item_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItemPage extends StatefulWidget {
  final String? itemId;
  const EditItemPage({super.key, required this.itemId});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemStockController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
      ),
      body: SingleChildScrollView(
          child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Customer Name',
                    labelText: 'Store Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _itemPriceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Phone number',
                    labelText: 'Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _itemStockController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Phone number',
                    labelText: 'Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your code here
                },
                child: const Text('Simpan'),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> _editItem() async {
    final ItemService _itemService =
        ItemService(firestore: FirebaseFirestore.instance);
    final itemName = _itemNameController.text;
    final itemPrice = _itemPriceController.text;
    final itemStock = _itemStockController.text;

    final previousData = await _itemService.getItem(widget.itemId!);

    final Item item = Item(
      id: widget.itemId!,
      articleCode: previousData!.articleCode,
      itemName: itemName,
      price: int.parse(itemPrice),
      totalStock: int.parse(itemStock),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: const Text('Are you sure you want to edit this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _itemService.updateItem(widget.itemId!, item);
                Navigator.of(context).pop();
              },
              child: const Text('Edit'),
            )
          ],
        );
      },
    );
  }
}
