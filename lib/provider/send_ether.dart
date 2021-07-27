import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class SendEther extends ChangeNotifier{
  String privakey;
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";

  Web3Client _client;


  Future<void> EtherSend(String receiPrivakey, BigInt etherNum) async{
    _client = Web3Client(_rpcUrl, Client(), socketConnector:() {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    } );
    Credentials credentials = await _client.credentialsFromPrivateKey(privakey);

    EthereumAddress ownAdress = await credentials.extractAddress();
    print(ownAdress);

    Credentials creden = await _client.credentialsFromPrivateKey(receiPrivakey);
    EthereumAddress receiver = await creden.extractAddress();
    print(receiver);
    _client.sendTransaction(
        credentials,
        Transaction(
            from: ownAdress,
            to: receiver,
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, etherNum)
        ));
  }

}