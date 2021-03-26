import 'package:flutter/material.dart';

import './edit_product_screen.dart';
import './products_overview_screen.dart';
import './orders_screen.dart';
import './user_products_screen.dart';
import './profile_screen.dart';
import '../widgets/custom_bottom_bar.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex;

  // static const int MAIN_PAGE = 0;
  // static const int ORDERS_PAGE = 1;
  // static const int USER_PRODUCTS_PAGE = 2;
  // static const int PROFILE_PAGE = 3;

  List<Widget> _pages = [
    ProductOverviewScreen(),
    OrderScreen(),
    UserProductsScreen(),
    ProfileScreen()
  ];

  // Widget _navigator = ProductOverviewScreen();
  @override
  initState() {
    super.initState();

    setState(() {
      _selectedPageIndex = 0;
    });
  }

  void _selectedTab(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // InkWell(

      // onTap: () =>
      //     Navigator.of(context).pushNamed(EditProductScreen.routeName),
      // child: Container(
      //   width: 40,
      //   height: 40,
      //   padding: EdgeInsets.all(8),
      //   decoration: new BoxDecoration(
      //     color: Theme.of(context).accentColor,
      //     borderRadius: BorderRadius.circular(40),
      //   ),
      // child: Icon(Icons.add),
      // ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Add Product',
        color: Colors.grey,
        backgroundColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).accentColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.store, text: 'Store'),
          FABBottomAppBarItem(iconData: Icons.payment, text: 'Orders'),
          FABBottomAppBarItem(iconData: Icons.edit, text: 'Edit Products'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
      ),
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(EditProductScreen.routeName),
        child: Icon(Icons.add),
        elevation: 2.0,
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   currentIndex: _selectedPageIndex,
      //   elevation: 8,

      //   unselectedItemColor: Colors.white,
      //   selectedItemColor: Theme.of(context).accentColor,
      //   backgroundColor: Theme.of(context).primaryColor,

      //   // type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      // icon: Icon(Icons.store),
      // label: 'Shop',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      // icon: Icon(Icons.payment),
      // label: 'Orders',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      // icon: Icon(Icons.edit),
      // label: 'Manage Products',
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      // icon: Icon(Icons.person),
      // label: 'Manage Products',
      //     ),
      //   ],
      // ),
    );
  }
}



// void _selectPage(int index) {
  //   // setState(() {
  //   //   _selectedPageIndex = index;
  //   // });
  //   print(Text('FAB SELECTED ---------------------------'));
  //   switch (index) {
  //     case MAIN_PAGE:
  //       setState(() {
  //         _navigator = ProductOverviewScreen();
  //       });
  //       break;
  //     case ORDERS_PAGE:
  //       setState(() {
  //         _navigator = OrderScreen();
  //       });
  //       break;
  //     case USER_PRODUCTS_PAGE:
  //       setState(() {
  //         _navigator = UserProductsScreen();
  //       });
  //       break;
  //     case PROFILE_PAGE:
  //       setState(() {
  //         _navigator = ProfileScreen();
  //       });
  //       break;
  //     default:
  //       setState(() {
  //         _navigator = ProductOverviewScreen();
  //       });
  //       break;
  //   }
  // }