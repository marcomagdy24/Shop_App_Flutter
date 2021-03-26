import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/products.dart';

class ProfileCustomList extends StatefulWidget {
  final double height;
  const ProfileCustomList(this.height);

  @override
  _ProfileCustomListState createState() => _ProfileCustomListState();
}

class _ProfileCustomListState extends State<ProfileCustomList> {
  List<String> listNumber;
  String productsLenght = "Load";
  String ordersLenght = "Load";

  @override
  Future didChangeDependencies() async {
    await Provider.of<Products>(context, listen: false)
        .itemsLenght
        .then((products) async {
      print("From List $products");
      productsLenght = products;
    });
    await Provider.of<Orders>(context, listen: false)
        .ordersLenght
        .then((orders) async {
      print("From List $orders");
      ordersLenght = orders;
    });
    setState(() {
      listNumber = [productsLenght, ordersLenght];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final listText = ["Number of Products", "Number of Orders"];
    final icons = [Icons.shop, Icons.payment];
    setState(() {
      listNumber = [productsLenght, ordersLenght];
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: listNumber == null
          ? CircularProgressIndicator()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listText.length,
              itemBuilder: (BuildContext context, int index) {
                return ProfileListItem(
                  text: listText[index],
                  number: listNumber[index],
                  iconData: icons[index],
                );
              },
            ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  const ProfileListItem({
    @required this.text,
    @required this.number,
    @required this.iconData,
  });

  final String text;
  final String number;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        color: Theme.of(context).primaryColorLight,
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24),
              ),
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          title: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: FittedBox(
                child: Text(
                  number,
                  // style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          // subtitle: Row(
          //   children: <Widget>[
          //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
          //     Text(" Intermediate", style: TextStyle(color: Colors.white))
          //   ],
          // ),
          // trailing: Icon(Icons.keyboard_arrow_right,
          //     color: Colors.white, size: 30.0),
        ),
      ),
    );
  }
}
