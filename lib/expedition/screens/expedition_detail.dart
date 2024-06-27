import 'dart:math';

import 'package:app_piutang_kenzy_baby/expedition/expedition_model.dart';
import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpeditionDetailPage extends StatelessWidget {
  final String? id;
  ExpeditionDetailPage({super.key, this.id});
  final ExpeditionService expeditionService =
      ExpeditionService(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: expeditionService.getExpedition(id!),
        builder: (context, AsyncSnapshot<Expedition?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            Expedition? expedition = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('Expedition Detail'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ListTile(
                    title: const Text('ID'),
                    subtitle: Text(expedition!.id),
                  ),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(expedition.name),
                  ),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(expedition.status),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text('No data found'));
        });
  }
}
