import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './cart_screen.dart';

// enum FilterOptions {
//   Favourites,
//   All,
// }
// enum ProductOverviewScreenState { Busy, DataRetrieved, NoData }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product-overview";
  @override
  State<StatefulWidget> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourites = false;
  // bool _isLoading = false;

  // Future<void> _fetchData() async {
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   // setState(() {
  //   //   _isLoading = false;
  //   // });
  // }

  @override
  // void initState() {
  //   print("hey from screen");
  //   _fetchData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawaer(),
      appBar: AppBar(
        title: const Text('Online Shopping'),
        actions: [
          Icon(
            _showOnlyFavourites ? Icons.favorite : Icons.thumb_up_alt_outlined,
          ),
          Switch(
            value: _showOnlyFavourites,
            onChanged: (val) {
              setState(() {
                _showOnlyFavourites = !_showOnlyFavourites;
              });
            },
          ),
          // PopupMenuButton(
          //   onSelected: (FilterOptions selectedValue) {
          //     setState(() {
          //       if (selectedValue == FilterOptions.Favourites) {
          //         _showOnlyFavourites = true;
          //       } else {
          //         _showOnlyFavourites = false;
          //       }
          //     });
          //   },
          //   icon: Icon(Icons.more_vert),
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favourites'),
          //       value: FilterOptions.Favourites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FilterOptions.All,
          //     ),
          //   ],
          // ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? CustomProgressIndicator()
                : ProductGrid(_showOnlyFavourites),
      ),

      // body: _isLoading
      //     ? CustomProgressIndicator()
      //     : ProductGrid(_showOnlyFavourites),
      // body: FutureBuilder(
      //   future:
      //       Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CustomProgressIndicator();
      //     } else {
      //       if (snapshot.error != null) {
      //         return const Center(
      //           child: const Text('Error'),
      //         );
      //       } else {
      //         print("hey2");
      //         return Consumer<Products>(
      //           builder: (ctx, _, __) => ProductGrid(_showOnlyFavourites),
      //         );
      //       }
      //     }
      //   },
      // ),
    );
  }
}
// child: ProductGrid(_showOnlyFavourites