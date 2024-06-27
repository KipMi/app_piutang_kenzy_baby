import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/item/item_service.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final List<AddedItem> allAddedItems = [];

@riverpod
List<AddedItem> addedItems(ref) {
  return allAddedItems;
}
