import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/provider/TodoList.dart';


class TodoScreen extends StatefulWidget {


  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController tx = TextEditingController();
    var listModel = Provider.of<TodoList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        backgroundColor: blueAc,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: listModel.isLoading
          ? Center( child: CircularProgressIndicator(),)
          : Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: ListView.builder(
                  itemCount: listModel.taskCount,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => ListTile(
                    leading: Checkbox(
                      value: listModel.todos[index].isCompleted,
                      onChanged: (value) {
                        if(mounted) {
                          setState(() {
                            // listModel.todos[index].isCompleted = !listModel.todos[index].isCompleted;
                            listModel.toogCompleted(BigInt.from(index + 1));
                          });
                        }
                      },
                    ),
                    title: Text(
                      listModel.todos[index].taskName,
                      style: TextStyle(
                        decoration: listModel.todos[index].isCompleted
                            ? TextDecoration.lineThrough
                            : null
                      ),
                    ),
                  )
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: tx,
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        listModel.addTask(tx.text);
                        tx.clear();
                      },
                      child: Text("ADD"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
