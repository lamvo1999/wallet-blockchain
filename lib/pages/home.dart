import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/Widgets/navigator.dart';
import 'package:wallet_blockchain/Widgets/widget.dart';
import 'package:wallet_blockchain/pages/generate.dart';
import 'package:wallet_blockchain/pages/qr_code.dart';
import 'package:wallet_blockchain/provider/ether.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var ether = Provider.of<Ether>(context);
    ether.initialSetUp();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 40, right: 30, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/logo.png"),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text("eWalle", style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ubuntu',
                          fontSize: 25
                      ),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Account Overview", style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                fontFamily: 'avenir'
            ),),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ether.balance == null
                      ? CircularProgressIndicator()
                      : Text(ether.balance.getValueInUnit(EtherUnit.ether).toString(),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                      ),),
                      SizedBox(height: 5,),
                      Text("Current Balance", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),)
                    ],
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffffac30),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Send Money", style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'avenir',
                ),),
                GestureDetector(
                  onTap: () {
                    changeScreen(context, SendQrCodeScreen());
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/scanqr.png'),
                        )
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffffac30),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ),
                  ),
                  avatarWidget("avatar1", "Mike"),
                  avatarWidget("avatar2", "Joseph"),
                  avatarWidget("avatar3", "Ashley"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Services", style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w800,
                ),),
                Container(
                  height: 60,
                  width: 60,
                  child: Icon(Icons.dialpad),
                ),
              ],
            ),
            Expanded(
              child: GridView.count(crossAxisCount: 4,
                childAspectRatio: 0.7,
                children: <Widget>[
                  serviceWidget("sendMoney", "Send\nMoney"),
                  serviceWidget("receiveMoney", "Receive\nMoney"),
                  serviceWidget("phone", "Mobile\nRecharge"),
                  serviceWidget("electricity", "Electricity\nBill"),
                  serviceWidget("tag", "Cashback\nOffer"),
                  serviceWidget("movie", "Movie\nTicker"),
                  serviceWidget("flight", "Flight\nTicker"),
                  serviceWidget("more", "More\n")

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}








