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
                      margin: EdgeInsets.only(bottom: 20.0),
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
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
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

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var errorMessage;
  final regEx = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
    print(_authData['email']);
    print(_authData['password']);
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
      print(e);
      errorMessage = "Could not authenticate you. Please try again later.";
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: _authMode == AuthMode.Signup ? 320 : 260,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
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
            offset: Offset(-5, -3),
            spreadRadius: 2,
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,

                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) return "Please provide an email";
                  if (!regEx.hasMatch(value)) return 'Invalid email!';
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                style: TextStyle(color: Colors.white),
                obscureText: true,
                controller: _passwordController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) return "Please provide a password";
                  if (value.length < 5) return 'Password is too short!';
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      style: TextStyle(color: Colors.white),
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          // ignore: missing_return
                          ? (value) {
                              if (value != _passwordController.text)
                                return 'Passwords do not match!';
                            }
                          : null,
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
                    elevation: MaterialStateProperty.all(8),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
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
