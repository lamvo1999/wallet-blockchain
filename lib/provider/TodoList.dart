import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/model/user.dart';
import 'package:wallet_blockchain/provider/auth.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoList extends ChangeNotifier{
  List<Task> todos = [];
  bool isLoading = true;
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  String privateKey;

  int taskCount = 0;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  Credentials _credentials;
  EthereumAddress _ownAddress;
  DeployedContract _contract;
  ContractFunction _taskCount;
  ContractFunction _tasks;
  ContractFunction _createTask;
  ContractFunction _toggleCompleted;
  ContractEvent _taskCreatedEvent;
  ContractEvent _taskCompletedEvent;
  List<String> topics;
  String data;

  TodoList(){
    initialSetUp();
  }

  Future<void> initialSetUp() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector:() {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    } );

    print(_client);
    await getAbi();
    await getCredentials();
    await getDeployContract();
  }
  Future<void> getAbi() async{
    String abiStringFile = await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

    print("Contrac Address: "+_contractAddress.toString());
  }

  Future<void> getCredentials() async{
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
    _ownAddress = await _credentials.extractAddress();
    print("todo Own Address: " + _ownAddress.toString());

  }

  Future<void> getDeployContract() async{
    _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "TodoList"), _contractAddress);

    _taskCount = _contract.function('taskCount');
    _tasks = _contract.function('tasks');
    _createTask = _contract.function('createTask');
    _toggleCompleted = _contract.function('toggleCompleted');
    _taskCreatedEvent = _contract.event('TaskCreated');
    _taskCompletedEvent = _contract.event('TaskCompleted');

    getTodos();
  }

  getTodos() async{
    List totalTaskList = await _client.call(contract: _contract, function: _taskCount, params: []);
    BigInt totalTasks = totalTaskList[0];
    taskCount = totalTasks.toInt();
    print("Tong Task: "+ totalTasks.toString());
    todos.clear();
    for(var i = 1; i< totalTasks.toInt()+1; i++){
      var temp = await _client.call(contract: _contract, function: _tasks, params: [BigInt.from(i)]);
      todos.add(Task(id: temp[0], taskName: temp[1], isCompleted: temp[2]));
    }
    print(todos[0].isCompleted);

    isLoading = false;
    notifyListeners();
  }

  addTask(String taskNameData) async{
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createTask,
            parameters: [taskNameData])
    );

    getTodos();
  }

  toogCompleted(BigInt id) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _toggleCompleted,
            parameters: [id])
    );

    getTodos();
  }
}


class Task{
  BigInt id;
  String taskName;
  bool isCompleted;
  Task({this.id, this.taskName, this.isCompleted});
}