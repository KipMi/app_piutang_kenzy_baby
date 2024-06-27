import 'package:app_piutang_kenzy_baby/customer_category/customer_category_model.dart';
import 'package:app_piutang_kenzy_baby/customer_category/customer_category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomerCategoryDetailPage extends StatelessWidget {
  final String? id;
  CustomerCategoryDetailPage({super.key, this.id});
  final CustomerCategoryService _customerCategoryService =
      CustomerCategoryService(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _customerCategoryService.getCustomerCategory(id!),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text('Customer Category ${data!.name}'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ListTile(
                    title: const Text('ID'),
                    subtitle: Text(data.id),
                  ),
                  ListTile(
                    title: const Text('Category Name'),
                    subtitle: Text(data.name),
                  ),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(data.status),
                  ),
                ],
              ));
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
