import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (_, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, null, []),
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Online Shopping',
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            primarySwatch: Colors.red,
            accentColor: Colors.black,
            fontFamily: 'Lato',

            // textTheme: TextTheme(
            //   bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   bodyText2: TextStyle(fontSize: 18),
            // ),

            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              labelStyle: TextStyle(
                color: Colors.white60,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.white38,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.white30,
                  width: 2.0,
                ),
              ),

              //fillColor: Colors.green
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.teal,
              actionTextColor: Colors.white,
              disabledActionTextColor: Colors.grey,
              contentTextStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              behavior: SnackBarBehavior.floating,
            ),
            cardTheme: CardTheme(
              elevation: 5,
              shadowColor: Theme.of(context).primaryColor,
            ),
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          },
        ),
      ),
    );
  }
}
