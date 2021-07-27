import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet_blockchain/model/style.dart';
import 'package:wallet_blockchain/provider/auth.dart';
import 'package:wallet_blockchain/provider/send_ether.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';



class SendQrCodeScreen extends StatefulWidget {

  @override
  _SendQrCodeScreenState createState() => _SendQrCodeScreenState();
}

class _SendQrCodeScreenState extends State<SendQrCodeScreen> {

  final _formKey = GlobalKey<FormState>();
  String qrCode = "Unknow";
  String recei = "sd";
  Web3Client _client;
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  TextEditingController ether ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ether = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ether.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var sendEther = Provider.of<SendEther>(context);
    auth.getUser();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.qr_code_scanner),),
                Tab(icon: Icon(Icons.qr_code),)
              ],
            ),
            title: Text(
              "Qr Code",
              style: TextStyle(
                  color: black
              ),
            ),
            backgroundColor: blueAc,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Enter the ether number you want to send:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: TextFormField(
                          controller: ether,
                          validator: (val) => val.isNotEmpty ? null : "Please enter ether",
                          autocorrect: false,
                          autofocus: false,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            fillColor: blueAc,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Number Ether",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_formKey.currentState.validate()){
                            scanQrcode();
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext){
                                  return Dialog(
                                    child: Container(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Bạn muốn chuyển" + ether.text +"ether đến địa chỉ dưới:"),
                                            Text(qrCode),
                                            RaisedButton(
                                              onPressed: (){
                                                sendEther.EtherSend(qrCode, BigInt.from(int.parse(ether.text)));
                                                Navigator.pop(context);
                                              },
                                              child: Text('Send Ether'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: blueAc,
                          ),
                          child: Center(
                            child: Text(
                                "Scan Qrcode",
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Scan the code to make a money transfer",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10,),
                        child: Text(
                          "My QRcode",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    QrImage(
                      data: auth.users.privateKey,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          child: Center(
                            child: Text(
                              "Uh Oh! Something Went Wrong..."
                            ),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Scan the code to make the transaction",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        )
    );
  }

  Future<void> scanQrcode() async {
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.QR);
      if(!mounted) return;
      setState(() {
        this.qrCode = qrCode;
        _client = Web3Client(_rpcUrl, Client(), socketConnector:() {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        } );
        Credentials creden =  _client.credentialsFromPrivateKey(qrCode) as Credentials;
        EthereumAddress receiver =  creden.extractAddress() as EthereumAddress;
        recei = receiver.toString();
      });
    } on PlatformException{
      qrCode = 'Failed';
    }
  }


}
