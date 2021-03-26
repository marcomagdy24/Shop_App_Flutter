import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/custom_list_profile.dart';

class ProfileScreen extends StatelessWidget {
  final double _raduis = 60;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    // print(user);
    return Scaffold(
      drawer: AppDrawaer(),
      appBar: AppBar(),
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CustomProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('Error'),
              );
            } else {
              return Column(
                children: [
                  Column(
                    children: [
                      CustomPaint(
                        size: Size(double.infinity, 100),
                        painter: ProfileCardPainter(
                          color: Theme.of(context).primaryColor,
                          avatarRadius: _raduis,
                          name:
                              user['name'] == "" ? "Loading..." : user["name"],
                        ),
                      ),

                      // if (user != null)
                      Container(
                        width: _raduis * 2,
                        height: _raduis * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(_raduis),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage(
                              'assets/images/person-placeholder.png',
                            ),
                            image: user["imageUrl"].toString().isEmpty
                                ? AssetImage(
                                    'assets/images/person-placeholder.png',
                                  )
                                : NetworkImage(user["imageUrl"]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ProfileCustomList(MediaQuery.of(context).size.height - 300),
                ],
              );
            }
          }
        },
      ),
    );
  }
}

class ProfileCardPainter extends CustomPainter {
  ProfileCardPainter(
      {@required this.color, @required this.avatarRadius, @required this.name});

  static const double _margin = 6;
  final Color color;
  final double avatarRadius;
  final String name;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds =
        Rect.fromLTWH(0, 0, size.width, size.height + avatarRadius);

    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarRect =
        Rect.fromCircle(center: centerAvatar, radius: avatarRadius)
            .inflate(_margin);

    final curvedShapeBounds = Rect.fromLTRB(
      shapeBounds.left,
      shapeBounds.top + shapeBounds.height * 0.35,
      shapeBounds.right,
      shapeBounds.bottom,
    );

    _drawBackground(canvas, shapeBounds, avatarRect, size.width);
    _drawCurvedShape(canvas, curvedShapeBounds, avatarRect);
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void _drawBackground(
      Canvas canvas, Rect bounds, Rect avatarRect, double width) {
    final paint = Paint()..color = color;
    TextSpan span = new TextSpan(
      text: name,
      style: TextStyle(
        fontFamily: "Anton",
        fontSize: 36,
        color: Color.fromARGB(255, 255, 246, 196),
      ),
    );
    final Size txtSize = _textSize(span.text, span.style);

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    final backgroundPath = Path()
      ..moveTo(bounds.left, bounds.top)
      ..lineTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarRect, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..close();

    canvas.drawPath(backgroundPath, paint);

    tp.paint(
        canvas,
        Offset(
          (width - txtSize.width) / 2,
          0,
        ));

    //tp.paint(canvas, new Offset(20, 20));
  }

  void _drawCurvedShape(Canvas canvas, Rect bounds, Rect avatarRect) {
    final colors = [color.darker(), color, color.darker()];
    final stops = [0.0, 0.3, 1.0];
    final gradient = LinearGradient(colors: colors, stops: stops);
    final paint = Paint()..shader = gradient.createShader(bounds);
    final handlePoint = Offset(bounds.left + (bounds.width * 0.25), bounds.top);

    final curvePath = Path()
      ..moveTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarRect, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..quadraticBezierTo(handlePoint.dx, handlePoint.dy, bounds.bottomLeft.dx,
          bounds.bottomLeft.dy)
      ..close();

    canvas.drawPath(curvePath, paint);
  }

  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return avatarRadius != oldDelegate.avatarRadius ||
        color != oldDelegate.color;
  }
}

extension ColorShades on Color {
  Color darker() {
    const int darkness = 10;
    int r = (red - darkness).clamp(0, 255);
    int g = (green - darkness).clamp(0, 255);
    int b = (blue - darkness).clamp(0, 255);
    return Color.fromRGBO(r, g, b, 1);
  }
}

  // FutureBuilder(
  //     future: Provider.of<Auth>(context, listen: false).fetchUserData(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: const CustomProgressIndicator());
  //       } else {
  //         if (snapshot.error != null) {
  //           return Center(
  //             child: Text('Error'),
  //           );
  //         } else {
// return

// AspectRatio(
//   aspectRatio: 0.1,
//   child: ClipOval(
//     child: FadeInImage.assetNetwork(
//       fit: BoxFit.cover,
//       image: user['imageUrl'],
//       placeholder: "assets/images/person-placeholder.png",
//     ),
//   ),
// ),
// CircleAvatar(
//   radius: _raduis,
//   backgroundImage: FadeInImage(
//     image: user['imageUrl'],
//     placeholder: "assets/images/person-placeholder.png",
//   ),
// ),
