import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/wrong_scan.dart';
import 'package:flutter/material.dart';
import 'success_scan.dart';
import 'wrong_scan.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';

class RessponseOfScanned extends StatefulWidget {
  final String walletAddress;
  const RessponseOfScanned({Key key, this.walletAddress}):super(key: key);

  @override
  _RessponseOfScannedState createState() => _RessponseOfScannedState(walletAddress: this.walletAddress);
}

class _RessponseOfScannedState extends State<RessponseOfScanned> {
  bool isWalletVerified = false;
  //it is for just testing of wrong page for now after seraching method created it will be the result of that method
  bool isWallet = true;
  String walletAddress;
  _RessponseOfScannedState({this.walletAddress});

  void initState(){
    print(walletAddress);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //foo();
    return isWallet?  SuccessScanned(walletAddress): WrongScanned();
  }
}