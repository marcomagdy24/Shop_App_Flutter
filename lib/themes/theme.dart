import 'package:flutter/material.dart';

import '../helpers/custom_route.dart';
import '../helpers/ui/app_colors.dart';
import '../helpers/ui/text_styles.dart';

// ThemeData(
//             // brightness: Brightness.dark,
//             primarySwatch: Colors.blue,
//             // primarySwatch: Colors.red,
//             // accentColor: Colors.black,
//             // primaryColor: Colors.lightBlue[800],
//             // accentColor: Colors.cyan[600],
//             primaryColor: Color(0xFFE91E63),
//             accentColor: Color(0xFF42A5F5),
//             fontFamily: 'Lato',
// pageTransitionsTheme: PageTransitionsTheme(builders: {
//   TargetPlatform.android: CustomPageTransitionBuilder(),
//   TargetPlatform.iOS: CustomPageTransitionBuilder(),
// }),

//             textTheme: TextTheme(
//               headline6:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),

//             inputDecorationTheme: InputDecorationTheme(
//               fillColor: Colors.white,
//               labelStyle: TextStyle(
//                 color: Colors.black54,
//               ),
//               errorStyle: TextStyle(color: Colors.blueGrey[200]),
// border: OutlineInputBorder(
//   borderRadius: BorderRadius.circular(
//     25.0,
//   ),
// borderSide: BorderSide(
//   color: Colors.white,
//   width: 2,
// ),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(
//                   25.0,
//                 ),
//                 borderSide: BorderSide(
//                   color: Colors.deepOrange[100],
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(
//                   25.0,
//                 ),
//                 borderSide: BorderSide(
//                   color: Colors.red.shade700,
//                   width: 2,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(25.0),
//                 borderSide: BorderSide(
//                   color: Colors.black54,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(25.0),
//                 borderSide: BorderSide(
// color: Colors.black54,
// width: 2.0,
//                 ),
//               ),

//               //fillColor: Colors.green
//             ),
//             snackBarTheme: SnackBarThemeData(
//               backgroundColor: Colors.teal,
//               actionTextColor: Colors.white,
//               disabledActionTextColor: Colors.grey,
//               contentTextStyle: TextStyle(fontSize: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//               behavior: SnackBarBehavior.floating,
//             ),
// cardTheme: CardTheme(
//   elevation: 5,
//   shadowColor: Theme.of(context).primaryColor,
// ),
//           )
final ThemeData appTheme = ThemeData(
  fontFamily: 'Lato',
  accentColor: accentColor,
  primaryColor: primaryColor,
  primaryColorLight: primaryLightColor,
  primaryColorDark: primaryDarkColor,
  // primaryTextTheme: he,
  secondaryHeaderColor: Colors.black54,
  backgroundColor: backgroundColor,
  cardColor: Colors.white,
  cardTheme: CardTheme(
    elevation: 5,
    shadowColor: primaryColor,
  ),
  bottomAppBarColor: primaryColor,
  dividerColor: dividerColor,
  hintColor: primaryColor,
  errorColor: primarySwatch,
  disabledColor: Colors.grey,
  scaffoldBackgroundColor: Colors.pink[40],
  iconTheme: IconThemeData(color: iconThemeColor),
  tabBarTheme: TabBarTheme(
    labelColor: primaryLightColor,
    unselectedLabelColor: textColor,
    indicator: BoxDecoration(
      color: textColor.withOpacity(0.1),
    ),
  ),
  primaryIconTheme: const IconThemeData(color: Colors.black54),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        25.0,
      ),
      borderSide: BorderSide(
        color: Colors.orange,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        25.0,
      ),
      borderSide: BorderSide(
        color: Colors.orange,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.black54,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.black54,
        width: 2.0,
      ),
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      color: textColor.withOpacity(0.7),
    ),
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
  // bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white, elevation: 2),
  textTheme: const TextTheme(
    subtitle1: subtitle1,
    subtitle2: subtitle2,
    headline3: headline3,
    headline4: headline4,
    headline5: headline5,
    headline6: headline6,
    button: button,
    caption: caption,
  ),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CustomPageTransitionBuilder(),
    TargetPlatform.iOS: CustomPageTransitionBuilder(),
  }),
);
