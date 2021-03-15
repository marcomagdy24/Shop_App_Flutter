import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final item = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Column(children: [
        Container(
          height: ((MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.horizontal) /
              2),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 5,
            shadowColor: Theme.of(context).primaryColor,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "\$${item.price}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            softWrap: true,
          ),
        ),
      ]),
    );
  }
}
