import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
