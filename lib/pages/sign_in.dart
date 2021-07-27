import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/Widgets/navigator.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/pages/SplashScreen.dart';
import 'package:wallet_blockchain/pages/home.dart';
import 'package:wallet_blockchain/pages/homeSidebar.dart';
import 'package:wallet_blockchain/pages/sign_up.dart';
import 'package:wallet_blockchain/provider/auth.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  bool _obscureText = true;
  String _password;
  TextEditingController _emailContro;
  TextEditingController _passContro;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirebaseAuth us = FirebaseAuth.instance;


  void _toggle() {
    if(mounted) {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailContro = new TextEditingController();
    _passContro = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailContro.dispose();
    _passContro.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            changeScreenReplacement(context, SplashSreen());
          },
        ),
        backgroundColor: Color(0xffe0e9f8),
        centerTitle: true,
        title: Text(
          'Welcome Back!',
          style: TextStyle(
            color: black,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xffe0e9f8),
          child: CustomScrollView(
            reverse: true,
            slivers: <Widget>[
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    Image.asset('images/login.png'),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 30,
                          bottom: 50,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: "Email Address",
                                      ),
                                      controller: _emailContro,
                                      validator: (val) => val.isNotEmpty ? null : "Please enter email address",
                                      autocorrect: false,
                                      autofocus: false,
                                    ),
                                    TextFormField(
                                      decoration:  InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: _toggle,
                                          icon: Icon(_obscureText ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                                        ),
                                        labelText: "Password",
                                      ),
                                      controller: _passContro,
                                      validator: (val) => val.length < 6 ? "Enter more than 6 char" : null,
                                      obscureText: _obscureText,
                                      autocorrect: false,
                                      autofocus: false,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Forget your password?',
                                          style: TextStyle(
                                              color: Color(0xff347af0),
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: (){
                                        if(_formKey.currentState.validate()){
                                          _isLoading = true;
                                          if(auth.signIn(_emailContro.text.trim(),_passContro.text.trim()) != null){
                                            _isLoading = false;
                                            changeScreenReplacement(context, homeWithSidebar());
                                          }
                                          _isLoading = false;
                                        }
                                      },
                                      color: Color(0xff347af0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          side: BorderSide(
                                            color: Color(0xff347af0),
                                          )
                                      ),
                                      child:_isLoading ?
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),)
                                      : Container(
                                        width: 160,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text('Login',
                                          style: TextStyle(
                                              color: Colors.white
                                          ),),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

