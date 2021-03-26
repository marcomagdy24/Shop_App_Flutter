import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/progress_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-detail";

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final item = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(item.title),
      // ),

      body: CustomScrollView(
        primary: true,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1,
                child: Text(
                  item.title,
                ),
              ),
              background: Hero(
                tag: item.id,
                child: Card(
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        CustomProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text(
                "\$${item.price}",
                textAlign: TextAlign.center,
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
              SizedBox(
                height: 800,
              )
            ]),
          )
        ],
      ),
    );
  }
}


// Column(children: [
//                 Container(
//                   height: ((MediaQuery.of(context).size.height -
//                           MediaQuery.of(context).padding.horizontal) /
//                       2),
//                   width: double.infinity,
// //                   padding: EdgeInsets.all(10),
//                   child: 
//                 ),
                
//               ]),