import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_blockchain/pages/SplashScreen.dart';
import 'package:wallet_blockchain/pages/home.dart';
import 'package:wallet_blockchain/pages/sign_in.dart';
import 'package:wallet_blockchain/pages/welcome_page.dart';
import 'package:wallet_blockchain/provider/TodoList.dart';
import 'package:wallet_blockchain/provider/auth.dart';
import 'package:wallet_blockchain/provider/ether.dart';
import 'package:wallet_blockchain/provider/send_ether.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        // ProxyProvider<Auth, TodoList>(
        //     update: (_, counter, __) => TodoList(counter.users.privateKey)),
        // ChangeNotifierProvider(create: (_) => TodoList("")),
        ChangeNotifierProxyProvider<Auth, TodoList>
          (create:(_) => TodoList(),
            update: (_, auth, todo) => todo
            ..privateKey = auth.users.privateKey,
        ),
        ChangeNotifierProxyProvider<Auth, Ether>
          (create:(_) => Ether(),
          update: (_, auth, ether) => ether
            ..privateKey = auth.users.privateKey,
        ),
        ChangeNotifierProxyProvider<Auth, SendEther>(
            create: (_) => SendEther(),
            update: (_, auth, sendther) => sendther
                ..privakey = auth.users.privateKey,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0.0,
                color: Colors.transparent,
                iconTheme: IconThemeData(
                  color: Colors.black,
                )
            )
        ),
        home: StartScreen(),
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with AfterLayoutMixin<StartScreen>{

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if(_seen) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => SplashSreen())
      );
    }else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => WelcomePage())
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}



