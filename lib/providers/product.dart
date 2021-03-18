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

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    toggleStatus();
    final url =
        'https://shop-app-f6161-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    final response = await http.put(
      Uri.parse(url),
      body: json.encode(isFavourite),
    );
    if (response.statusCode >= 400) {
      toggleStatus();
      throw HttpException('Something went wrong!');
    }
  }
}
