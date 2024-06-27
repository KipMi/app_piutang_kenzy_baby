import 'package:app_piutang_kenzy_baby/item/item_model.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/providers/add_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddedItemNotifier extends Notifier<Set<AddedItem>> {
  @override
  Set<AddedItem> build() {
    return {};
  }

  void addItems(AddedItem item) {
    if (!state.contains(item)) {
      state = {...state, item};
    }
  }

  void removeItems(AddedItem item) {
    state = state.where((element) => element != item).toSet();
  }

  void clear() {
    state = {};
  }
}

final addedItemNotifierProvider =
    NotifierProvider<AddedItemNotifier, Set<AddedItem>>(() {
  return AddedItemNotifier();
});
