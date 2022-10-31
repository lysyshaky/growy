import 'package:flutter/material.dart';
import 'package:growy/models/viewed_model.dart';
import 'package:growy/models/wishlist_model.dart';

import '../models/cart_model.dart';

class ViewedProdProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _viewedProdlistItems = {};

  Map<String, ViewedProdModel> get getViewedProdlistItems {
    return _viewedProdlistItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdlistItems.putIfAbsent(
        productId,
        () => ViewedProdModel(
            id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _viewedProdlistItems.clear();
    notifyListeners();
  }
}
