import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../widgets/progress_indicator.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.9),
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_outline,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                try {
                  await product.toggleFavouriteStatus(
                      authData.token, authData.userId);
                } catch (_) {
                  scaffold.showSnackBar(
                    SnackBar(content: Text('Something went wrong!')),
                  );
                }
              },
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added Item to the cart Successfully!'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeOneItem(product.id);
                      },
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }),
          backgroundColor: Colors.black87,
          title: Text(
            '${product.title[0].toUpperCase()}${product.title.substring(1)}',
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                fit: BoxFit.cover,
                imageErrorBuilder: (context, __, _) =>
                    CustomProgressIndicator(),
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
