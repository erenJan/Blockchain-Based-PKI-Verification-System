import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'scanner_camera.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/visual/stickbar.dart';
class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(40),
          topRight: const Radius.circular(40)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: <Widget>[
          StickBar(),
          ScannerCamera(),
          
        ],
      ),
    );
  }
}





