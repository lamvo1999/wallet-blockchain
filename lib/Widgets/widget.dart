import 'package:flutter/material.dart';
import 'package:wallet_blockchain/Widgets/navigator.dart';
import 'package:wallet_blockchain/pages/Todo.dart';
import 'package:wallet_blockchain/pages/home.dart';
import 'package:wallet_blockchain/pages/homeSidebar.dart';
import 'package:wallet_blockchain/pages/profile_screen.dart';

Widget avatarWidget(String img, String name){
  return Container(
    margin: EdgeInsets.only(right: 10),
    height: 150,
    width: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Color(0xfff1f3f6),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('images/$img.png'),
              fit: BoxFit.contain,
            ),
            border: Border.all(
                color: Colors.black,
                width: 2
            ),
          ),
        ),
        Text(name, style: TextStyle(
            fontSize: 16,
            fontFamily: 'avenir',
            fontWeight: FontWeight.w700
        ),)
      ],
    ),
  );
}

Column serviceWidget(String img, String name){
  return Column(
    children: <Widget>[
      Expanded(
        child: InkWell(
          onTap: (){},
          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xfff1f3f6),
            ),
            child: Center(
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/$img.png')
                    )
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 5,),
      Text(name, style: TextStyle(
        fontFamily: 'avenir',
        fontSize: 14,
      ),textAlign: TextAlign.center,),
    ],
  );
}

GestureDetector navigatorTitle(BuildContext context,String name, bool isSelected)
{
  return GestureDetector(
    onTap: (){
      switch(name) {
        case 'Home':
          changeScreen(context, HomePage());
          break;
        case 'Profile':
          changeScreen(context, ProfileSceen());
          break;
        case 'Accounts':
          changeScreen(context, HomePage());
          break;
        case 'Transactions':
          changeScreen(context, HomePage());
          break;
        case 'Todo':
          changeScreen(context, TodoScreen());
          break;
        case 'Settings':
          changeScreen(context, HomePage());
          break;
        case 'Help':
          changeScreen(context, HomePage());
          break;
        default:
          break;
      }
    },
    child: Row(
      children: [
        (isSelected) ? Container(
          width: 5,
          height: 60,
          color: Color(0xffffac30),
        ):
        Container(width: 5,
          height: 60,),
        SizedBox(width: 10,height: 60,),
        Text(name, style: TextStyle(
            fontSize: 16,
            fontWeight: (isSelected) ? FontWeight.w700: FontWeight.w400
        ),)
      ],
    ),
  );
}

class OneTo extends StatelessWidget {
  final String taskName;
  final bool isCompleted;

  const OneTo({Key key, this.taskName, this.isCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
              value: isCompleted,
              onChanged: (isComplete) {

              }),
          Text(taskName)
        ],
      ),
    );
  }
}