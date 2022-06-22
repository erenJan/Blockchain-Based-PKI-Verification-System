import 'package:beChain/wallet/appBar/qr_scanner/scanner_camera.dart';
import 'package:flutter/material.dart';
import 'pop_up_context.dart';

void QrPopUp(context){
  showModalBottomSheet(
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (context){
      return new Container(
        color: Colors.transparent,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: ScannerPage()
        )
      );
    }
  );
}