import 'package:app_piutang_kenzy_baby/expedition/expedition_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpeditionTablePage extends StatefulWidget {
  const ExpeditionTablePage({super.key});

  @override
  State<ExpeditionTablePage> createState() => _ExpeditionTablePageState();
}

class _ExpeditionTablePageState extends State<ExpeditionTablePage> {
  final _expeditionService =
      ExpeditionService(firestore: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition Table'),
      ),
      body: StreamBuilder(
        stream: _expeditionService.getAllExpeditions(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Expedition Name')),
                    DataColumn(label: Text('Created At')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    for (final expedition in snapshot.data!.docs)
                      DataRow(
                        cells: [
                          DataCell(Text(expedition['name'])),
                          DataCell(Text(expedition['status'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => EditExpeditionPage(
                                  //       expeditionId: expedition.id,
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Delete Confirmation'),
                                          content: const Text(
                                              'Are you sure you want to delete this expedition?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _expeditionService
                                                    .deleteExpedition(
                                                        expedition.id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          )),
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
