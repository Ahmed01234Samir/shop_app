//import 'dart:ffi';
// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(215, 188, 255, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: 800,
              width: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                   // transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      "My Shop",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton'),
                    ),
                  )),
                  Flexible(
                    flex: 800 > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum Authmode { Login, Signup }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Authmode _authmode = Authmode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  var _isloading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    setState(() {
      _isloading = true;
    });
    try {
      if (_authmode == Authmode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!);
      }
    } on HttpExcepction catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_Exist')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = '';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isloading = false;
    });
  }

  void _switchAuthMode() {
    if (_authmode == Authmode.Login) {
      setState(() {
        _authmode = Authmode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authmode = Authmode.Login;
      });
      _controller.reverse();
    }
  }

  // ignore: non_constant_identifier_names
  void _showErrorDialog(String Message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(Message),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('okay!'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
   // final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authmode == Authmode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authmode == Authmode.Signup ? 320 : 260,
        ),
        width: 800 * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val!.isEmpty || !val.contains("@")) {
                    return 'invalid email';
                  }
                  return null;
                },
                onSaved: (val) {
                  _authData['email'] = val!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (val) {
                  if (val!.isEmpty || val.length < 5) {
                    return 'password is too short!';
                  }
                  return null;
                },
                onSaved: (val) {
                  _authData['password'] = val!;
                },
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                constraints: BoxConstraints(
                    minHeight: _authmode == Authmode.Signup ? 60 : 0,
                    maxHeight: _authmode == Authmode.Signup ? 120 : 0),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      enabled: _authmode == Authmode.Signup,
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authmode == Authmode.Signup
                          ? (val) {
                              if (val != _passwordController.text) {
                                return 'password do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_isloading) CircularProgressIndicator(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
                child: Text(_authmode == Authmode.Login ? 'Login' : 'Signup'),
                onPressed: _submit,
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                    '${_authmode == Authmode.Login ? 'Signup' : 'Login'} Instead'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
              )
            ],
          )),
          key: _formKey,
        ),
      ),
    );
  }
}
