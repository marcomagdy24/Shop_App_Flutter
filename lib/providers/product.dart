import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    toggleStatus();
    final url =
        'https://shop-app-f6161-default-rtdb.firebaseio.com/products/$id.json';
    final response = await http.patch(Uri.parse(url),
        body: json.encode({'isFavourite': this.isFavourite}));
    if (response.statusCode >= 400) {
      toggleStatus();
      throw HttpException('Something went wrong!');
    }
  }
}
