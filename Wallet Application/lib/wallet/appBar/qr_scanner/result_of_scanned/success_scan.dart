import 'dart:io';
import 'package:beChain/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'certificate_page/certificiate_pop_up.dart';
import 'package:path_provider/path_provider.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/bookWallet.dart';

class SuccessScanned extends StatefulWidget {
  SuccessScanned(String walletAddress, {Key key}) : super(key: key);

  

  @override
  _SuccessScannedState createState() => _SuccessScannedState();
}

class _SuccessScannedState extends State<SuccessScanned> {

  

  String signature = "0x0a13B36b926f9A7d101e2c293d16B2Fd990e97d0";
  var placeHolderController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Container(
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0,right: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QrImage(
                        //data: isQrVisible? result.code : "",
                        data: "erencanerel",
                        version: QrVersions.auto,
                        size: 160.0,
                        foregroundColor: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Container(
                          child: Icon(Icons.verified_outlined,color: Colors.white,size: 60.0,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30.0,top: 10,right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Signature",style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.left,),
                        Text(signature,style: TextStyle(color: Colors.blueGrey,fontSize: 10),),
                      ],
                    ),
                    GestureDetector(
                      child: Container(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Icon(Icons.plagiarism_rounded,color: Colors.white,size: 34,),
                        ),
                      ),
                      onTap: (){CertificatePopUp(context,signature);},
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30.0,right: 30.0,top:50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue
                        ),
                        height: 50,
                        child: Center(
                          child: Text("Make Transaction",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: GestureDetector(
                        child: Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(Icons.save_rounded ,color: Colors.white,size: 36,),
                          ),
                        ),
                        onTap: (){
                          showDialog(
                            context: context, 
                            builder: (BuildContext context){
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)
                                ),
                                elevation:0,
                                backgroundColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 24,top: 69,right: 24,bottom: 24),
                                        margin: EdgeInsets.only(top: 45),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: background,
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black,offset: Offset(0,10),blurRadius: 10)
                                          ]
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Save This Wallet",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                            SizedBox(height: 15,),
                                            Text("You can type here to save this wallet to your account list after that you can easly select from there!",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                                            Form(
                                              child:Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                    controller: placeHolderController,
                                                    style: TextStyle(color: Colors.white),
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(color: Colors.white),
                                                      labelText: "Save Wallet As",
                                                      hintText: 'Type Here',
                                                      hintStyle: TextStyle(color: Colors.white),
                                                      enabledBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white))
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                            SizedBox(height: 15,),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: FlatButton(
                                                color: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                  
                                                ),
                                                onPressed: (){
                                                  print(placeHolderController.text);
                                                  BookWalletFromScan(placeHolderController.text,signature);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("SAVE",style: TextStyle(color: Colors.white),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 24,
                                        right: 24,
                                        child: CircleAvatar(
                                          backgroundColor: background,
                                          radius: 45,
                                          child: Icon(Icons.save_rounded,color: Colors.white,size: 50,),
                                        ),
                                      )
                                    ],
                                    
                                  )
                                ),
                              );
                            }
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ], 
          );
  }
}