import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/item/item_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _createItemKey = GlobalKey<FormState>();

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _itemService = ItemService(firestore: FirebaseFirestore.instance);

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemStockController = TextEditingController();
  final TextEditingController _itemArticleCodeController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Item'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _createItemKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemArticleCodeController,
                  validator: (value) => value!.isEmpty
                      ? 'Item article code cannot be empty'
                      : null,
                  decoration: const InputDecoration(
                      labelText: 'Item Article Code',
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Item name cannot be empty' : null,
                  decoration: const InputDecoration(
                      labelText: 'Item Name', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                      value!.isEmpty ? 'Item price cannot be empty' : null,
                  decoration: const InputDecoration(
                      labelText: 'Item Price', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemStockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                      value!.isEmpty ? 'Item stock cannot be empty' : null,
                  decoration: const InputDecoration(
                      labelText: 'Item Stock', border: OutlineInputBorder()),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Create Item'),
                        content: const Text(
                            'Are you sure you want to create this item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              createItem();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Create'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Text('Create Item'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void createItem() async {
    if (_createItemKey.currentState!.validate()) {
      final itemName = _itemNameController.text;
      final price = int.parse(_itemPriceController.text);
      final totalStock = int.parse(_itemStockController.text);
      final itemArticleCode = _itemArticleCodeController.text;

      await _itemService.createItem(Item(
          articleCode: itemArticleCode,
          itemName: itemName,
          price: price,
          totalStock: totalStock));

      if (_itemService.hasError) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(_itemService.errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            );
          },
        );
      } else {
        _itemNameController.clear();
        _itemPriceController.clear();
        _itemStockController.clear();
        _itemArticleCodeController.clear();
      }
    }
  }
}
