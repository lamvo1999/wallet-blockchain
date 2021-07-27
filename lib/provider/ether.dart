import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wallet_blockchain/model/user.dart';
import 'package:wallet_blockchain/provider/auth.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Ether extends ChangeNotifier{
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
  EtherAmount balance;

  TodoList(){
    initialSetUp();
  }

  Future<void> initialSetUp() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector:() {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    } );

    print(_client);
    await getAbi();
    await getBalance();
    // await getDeployContract();
  }
  Future<void> getAbi() async{
    String abiStringFile = await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);

    print("Contrac Address: "+_contractAddress.toString());
  }

  Future<void> getBalance() async{
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
    _ownAddress = await _credentials.extractAddress();
    print("Own Address: " + _ownAddress.toString());
    balance = await _client.getBalance(_ownAddress) as EtherAmount;
    print(balance.getValueInUnit(EtherUnit.ether));

  }



}
