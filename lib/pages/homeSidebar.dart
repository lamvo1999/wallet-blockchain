import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/Widgets/navigator.dart';
import 'package:wallet_blockchain/Widgets/widget.dart';
import 'package:wallet_blockchain/model/user.dart';
import 'package:wallet_blockchain/pages/SplashScreen.dart';
import 'package:wallet_blockchain/pages/home.dart';
import 'package:wallet_blockchain/provider/auth.dart';


class HomeWithSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWithSidebar(),
    );
  }
}
class homeWithSidebar extends StatefulWidget {
  final BuildContext context;

  const homeWithSidebar({Key key, this.context}) : super(key: key);

  @override
  _homeWithSidebarState createState() => _homeWithSidebarState();
}

class _homeWithSidebarState extends State<homeWithSidebar> with TickerProviderStateMixin{
  bool sideBarActive = true;
  AnimationController rotationController;
  var auth;

  @override
  void initState() {
    // TODO: implement initState
    rotationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<Auth>(context);
    auth.getUser();

    return Scaffold(
      backgroundColor: Color(0xfff1f3f6),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
                        color: Colors.white
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfff1f3f6),
                                image: DecorationImage(
                                    image: auth.users.profilePhoto != null
                                        ? NetworkImage(auth.users.profilePhoto)
                                        : AssetImage('images/avatar4.png'),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(auth.users.username != null ?auth.users.username : "cu Lâm", style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text(auth.users.email != null ?auth.users.email : "!", style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child:navigatorTitle(context,"Home", true), ),
                    Expanded(
                      child: navigatorTitle(context, "Profile", false), ),
                    Expanded(
                      child: navigatorTitle(context, "Accounts", false), ),
                    Expanded(
                      child: navigatorTitle(context, "Transactions", false), ),
                    Expanded(
                      child: navigatorTitle(context, "Todo", false), ),
                    Expanded(
                      child:navigatorTitle(context, "Settings", false), ),
                   Expanded(
                     child: navigatorTitle(context, "Help", false),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  auth.signOut();
                  changeScreenReplacement(context, SplashSreen());
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 30,
                      ),
                      Text("Logout", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),)
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(20),
                child: Text("Ver 2.0.1",style: TextStyle(
                    color: Colors.grey
                ),),
              )
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: (sideBarActive) ? MediaQuery.of(context).size.width*0.6 : 0,
            top: (sideBarActive)? MediaQuery.of(context).size.height*0.2 : 0,
            child: RotationTransition(
              turns: (sideBarActive) ? Tween(begin: -0.05, end: 0.0).animate(rotationController) : Tween(begin: 0.0, end: -0.05).animate(rotationController),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: (sideBarActive) ? MediaQuery.of(context).size.height*0.7 : MediaQuery.of(context).size.height,
                width: (sideBarActive) ? MediaQuery.of(context).size.width*0.8 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: HomePage(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: (sideBarActive) ? IconButton(
              padding: EdgeInsets.all(30),
              onPressed: closeSideBar,
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
            ): InkWell(
              onTap: openSideBar,
              child: Container(
                margin: EdgeInsets.all(30),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/menu.png')
                    )
                ),
              ),

            ),
          )
        ],
      ),
    );
  }

  void closeSideBar()
  {
    sideBarActive = false;
    if(mounted){
    setState(() {

    });
    }
  }
  void openSideBar()
  {
    sideBarActive = true;
    if(mounted) {
      setState(() {

      });
    }
  }
}