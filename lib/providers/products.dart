import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

// import '../data/Products.dart';
import './product.dart';

class Products with ChangeNotifier {
  // List<Product> _items = products;
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return [..._items.where((element) => element.isFavourite)];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://shop-app-f6161-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(Uri.parse(url));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final favUrl =
          'https://shop-app-f6161-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favResponse = await http.get(Uri.parse(favUrl));
      // print(json.decode(favResponse.body));
      final userFav = json.decode(favResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, product) {
        loadedProducts.add(Product(
          id: productId,
          title: product['title'],
          imageUrl: product['imageUrl'],
          description: product['description'],
          price: product['price'],
          isFavourite: userFav == null ? false : userFav[productId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-f6161-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((product) => product.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-f6161-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw (error);
      }
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-f6161-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}
