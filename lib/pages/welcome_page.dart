
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_blockchain/model/items.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/pages/SplashScreen.dart';
import 'package:wallet_blockchain/pages/home.dart';

class WelcomePage extends StatelessWidget {
  final _pageViewController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xffe0e9f8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(45),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SplashSreen())
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
            ),
          )
        ],
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Image.asset(
                Items.welcomeData[index]['image'],
                width: ScreenUtil().setWidth(326),
                height: ScreenUtil().setHeight(240),
              ),
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(375),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              4,
                                  (indicator) => Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: indicator == index
                                      ? blue
                                      : dot,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          Items.welcomeData[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontSize: ScreenUtil().setSp(30),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        Text(
                          Items.welcomeData[index]['text'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primary,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          onPressed: () {
                            if (index < 3) {
                              _pageViewController.animateToPage(index + 1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            } else {}
                          },
                          color: index != 3
                              ? Colors.transparent
                              : blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: blue,
                            ),
                          ),
                          child: Container(
                            width: ScreenUtil().setWidth(160),
                            height: 40,
                            alignment: Alignment.center,
                            child: index != 3 ? Text(
                              'Next Step',
                              style: TextStyle(
                                color: blue,
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            :GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => SplashSreen())
                                );
                              },
                              child: Text(
                                'Let\'s Get Started',
                                style: TextStyle(
                                  color: white,
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 4,
      ),
    );
  }
}
