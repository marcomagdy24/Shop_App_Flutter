import 'package:flutter/cupertino.dart';

import '../data/Products.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = products;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return [..._items.where((element) => element.isFavourite)];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
    notifyListeners();
  }
}
