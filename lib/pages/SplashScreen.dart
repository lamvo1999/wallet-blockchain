import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/pages/homeSidebar.dart';
import 'package:wallet_blockchain/pages/sign_in.dart';
import 'package:wallet_blockchain/pages/sign_up.dart';
import 'package:http/http.dart' as http;

class SplashSreen extends StatefulWidget {
  const SplashSreen({Key key}) : super(key: key);

  @override
  _SplashSreenState createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  String dat = DateFormat('MMM d, yyyy | EEEE').format(DateTime.now());// prints Tuesday, 10 Dec, 2019
  TimeOfDay _timeOfDay = TimeOfDay.now();
  var temp;

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/weather?q=Danang&units=metric&appid=88dbcf6dbcaf693d64265772ce55363d"));
    var result  = jsonDecode(response.body);
    if(mounted) {
      setState(() {
        this.temp = result['main']['temp'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getWeather();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/sideImg.png'),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.7,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${_timeOfDay.hour}:${_timeOfDay.minute}",
                      style: TextStyle(
                        fontSize: 30
                      ),
                    ),
                    Text(_period),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 15,
                      width: 20,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/cloud.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(temp.toString() + "\u00B0C", style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w800
                    ),)
                  ],
                ),
                Text(dat,style : TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text("eWalle", style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'ubuntu',
                          fontWeight: FontWeight.w600,
                        ),),
                        SizedBox(height: 10,),
                        Text("Open An Account For \nDigital E-Wallet Solution. \nInstant Payouts.\n\n Join For Free", style: TextStyle(
                            color: Colors.grey
                        ),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInScreen())
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xffffac30),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Sign In", style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          ),),
                          Icon(Icons.arrow_forward, size: 17,)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          }
                      ));
                    },
                    child: Text("Create an account", style: TextStyle(
                        fontSize: 16
                    ),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
