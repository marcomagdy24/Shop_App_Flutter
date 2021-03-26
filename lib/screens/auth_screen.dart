import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/progress_indicator.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffc31432),
                  Color(0xff240b36),

                  // Color(0xff0f2027),
                  // Color(0xff203a43),
                  // Color(0xff2c5364),

                  // Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  // Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  // Colors.black.withOpacity(0.8),
                  // Colors.red[700].withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                        // top: MediaQuery.of(context).padding.top,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFc31432),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    // flex: deviceSize.width > 600 ? 2 : 1,

                    // flex: 3,

                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final labelStyle = TextStyle(color: Colors.white60);
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusController = FocusNode();
  final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(
      color: Colors.white54,
    ),
  );
  final enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(
      color: Colors.white54,
      width: 2.0,
    ),
  );

  final GlobalKey<FormState> _formKey = GlobalKey();
  var errorMessage = "";
  final regEx = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'imageUrl': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  bool errorText = false;

  double _currentHeight = 0;
  AnimationController _controller;
  // Animation<Size> _heightAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _offsetAnimation;

  void _updateImageUrl() {
    if (!_imageUrlFocusController.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _imageUrlFocusController.addListener(_updateImageUrl);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    // _heightAnimation = Tween<Size>(
    //   begin: Size(double.infinity, 260),
    //   end: Size(double.infinity, 320),
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // ));
    _offsetAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _imageUrlController.text = _authData['imageUrl'];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    _imageUrlFocusController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Okay",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text("An error occured"),
    //     content: Text(message),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text("Okay"),
    //       )
    //     ],
    //   ),
    // );
  }

  Future<void> _submit() async {
    // print(_authData['email']);
    // print(_authData['password']);
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
          _authData['name'],
          _authData['imageUrl'],
        );
      }
    } on HttpException catch (e) {
      errorMessage = "Authentication failed";
      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email is already exists.";
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Invalid Email.";
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "This email is not found.";
      } else if (e.toString().contains("USER_DISABLED")) {
        errorMessage = "This email has been disabled by an administrator.";
      } else if (e.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        errorMessage = "Unusual activity occured. Try again later.";
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid Password.";
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak.";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      // print(e);
      errorMessage = "Could not authenticate you. Please try again later.";
      _showErrorDialog(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        // errorText = false;
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        // errorText = false;
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // print(errorText);
    if (_authMode == AuthMode.Signup) {
      if (errorText) {
        _currentHeight = 500;
      } else {
        _currentHeight = 450;
      }
    } else {
      if (errorText) {
        _currentHeight = 300;
      } else {
        _currentHeight = 260;
      }
    }
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      height: _currentHeight,
      // height: 50000,

      width: min(deviceSize.width * 0.75, 350),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA31233),
            offset: Offset(3, 5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
          BoxShadow(
            color: Color(0xFF440D35),
            offset: Offset(-3, -5),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xffc31432),
            Color(0xff240b36),

            // Color(0xff0f2027),
            // Color(0xff203a43),
            // Color(0xff2c5364),

            // Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            // Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            // Colors.black.withOpacity(0.8),
            // Colors.red[700].withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 1],
        ),
      ),

      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: labelStyle,
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    errorText = true;
                    // print("No Email");
                    return "Please provide an email";
                  }
                  if (!regEx.hasMatch(value)) {
                    errorText = true;
                    // print("Invalid Email");
                    return "Please provide valid format for email";
                  }
                  // print("No Error in Email");
                  errorText = false;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: labelStyle,
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 8,
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    errorText = true;
                    // print('No password');
                    return "Please provide a password";
                  }
                  if (value.length < 5) {
                    errorText = true;
                    // print('Short pass');
                    return 'Password is too short!';
                  }
                  // print('No error in pass');
                  errorText = false;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                Column(
                  children: [
                    SizedBox(height: 10),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enabled: _authMode == AuthMode.Signup,
                              style: TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: labelStyle,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                              ),
                              obscureText: true,
                              validator: _authMode == AuthMode.Signup
                                  // ignore: missing_return
                                  ? (value) {
                                      if (value.isEmpty) {
                                        errorText = true;
                                        return "Please provide a match password";
                                      }
                                      if (value != _passwordController.text) {
                                        errorText = true;
                                        return 'Passwords do not match!';
                                      }
                                      errorText = false;
                                    }
                                  : null,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              enabled: _authMode == AuthMode.Signup,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: 'Your Name',
                                labelStyle: labelStyle,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  errorText = true;
                                  return "Please provide your name";
                                }
                                errorText = false;
                              },
                              onSaved: (value) {
                                _authData['name'] = value;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              enabled: _authMode == AuthMode.Signup,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: 'Your Image as Url',
                                labelStyle: labelStyle,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                prefixIcon: _imageUrlController.text.isEmpty ||
                                        _imageUrlController.text == ""
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.fill,
                                          width: 30,
                                          height: 30,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                          // scale: 15,
                                        ),
                                      ),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusController,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide an Image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please provide a valid Image URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please provide a valid Image URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['imageUrl'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              if (_isLoading)
                CustomProgressIndicator()
              else
                ElevatedButton(
                  child: Ink(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFC31432),
                          Color(0xFF440D35),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(minHeight: 50.0, minWidth: 100),
                      alignment: Alignment.center,
                      child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(color: Colors.red[200]),
                      ),
                    ),
                  ),
                  onPressed: _submit,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    elevation: MaterialStateProperty.all(6),
                    shadowColor:
                        MaterialStateProperty.all(Colors.grey.shade500),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                        side: BorderSide(
                          color: Colors.grey.shade400,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              TextButton(
                child: Text(
                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  style: TextStyle(color: Colors.red[200]),
                ),
                onPressed: _switchAuthMode,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
