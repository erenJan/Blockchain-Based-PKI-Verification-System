import 'dart:convert';

import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/success_scan.dart';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/scanned_wallet.dart';

import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/recieve_screen/certificatedRecieve.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/recieve_screen/uncertificatedRecieve.dart';


//camera section
class ScannerCamera extends StatefulWidget {
  const ScannerCamera({
    Key key,
  }) : super(key:key);
  @override
  State<ScannerCamera> createState() => _ScannerCameraState();
}

class _ScannerCameraState extends State<ScannerCamera> {
  var qrText = "";
  bool isQrVisible = false;
  bool isWalletVerified = true;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          child: Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blueAccent,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 5,
                overlayColor: background
              ),
            ),
            flex:4
          ),
        ),
        Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:20.0,right:20.0,top:20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Scanning...",textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24))),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:20.0,right:20.0,top:10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Place qr code inside the frame to scan \nplease avaoid shake to get result quickly",textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 14))),
              ),
            ),
          ],
        )
      ],
    );
  }
  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        result = scanData;
        controller?.pauseCamera();
        List a = result.code.split(":");
        a = a.toString().split(",");
        String type = a[5].replaceAll(" ","");
        type = type.replaceAll("]","");
        print(type.runtimeType);
        print(type[0]);
        if(type == "certificated"){
          print("ahahah");
        }
        if(type[0] == "w"){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuccessScanned(a[1])),
            );
        }else{
          if(type[0] == "c"){
            print("here");
            Navigator.pop(context);
            recieveCertificated(context,a[1],a[3]);
          }else{
            print("exit");
            Navigator.pop(context);
            recieveUncertificated(context,a[1],a[3]);
          }
        }
      });
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
}