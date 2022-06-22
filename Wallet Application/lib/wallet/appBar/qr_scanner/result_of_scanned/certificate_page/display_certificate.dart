import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/visual/stickbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beChain/wallet/style/style.dart';

class Certificate extends StatefulWidget {
  final String signature_value;
  const Certificate({Key key, this.signature_value}) : super(key: key);

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  
  @override
  Widget build(BuildContext context) {
    String ownersName = "Erencan Erel";
    String year = "2022";
    String refferal = "0001";
    return Container(
      height: 200,
      child: Column(
        children: [
          StickBar(),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text("year: "+year,textAlign: TextAlign.start,style: TextStyle(color: Colors.white),)
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text("Refferal No: "+refferal,textAlign: TextAlign.start,style: TextStyle(color: Colors.white),)
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0,left: 10.0,right: 20.0),
            child: Text("Certificate of Authority",style: GoogleFonts.luxuriousScript(color:Colors.white,fontSize: 52,fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:20.0,top:0),
            child: RichText( 
              textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:"This is certify that ",
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(text: ownersName, style:GoogleFonts.luxuriousScript(color: shadePurple,fontSize: 36)),
                    TextSpan(text:" is the owner of verificated wallet. BeChain Institution guaranteeds identification of wallet owner.",style: TextStyle(color: Colors.white,height: 2.2))
                  ]
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Signature",style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.left,),
                        Text(widget.signature_value.substring(0,16)+"...."+widget.signature_value.substring(40,64),style: TextStyle(color: Colors.blueGrey,fontSize: 8),),
                      ],
                    ),
                Image.asset('assets/verified.png',height: 100,width: 100,),
              ],
            ),
          )
          
        ],
      ),
    );
  }
}