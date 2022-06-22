import 'dart:ui';
import 'dart:async';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:beChain/wallet/wallet_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/visual/stickbar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:secp256k1/secp256k1.dart';

import 'package:beChain/wallet/card/new_card/new_wallet/wallet_genaration.dart';
import 'package:beChain/wallet/card/new_card/new_wallet/check_name.dart';


void addWalletPopUp(context){
  showModalBottomSheet(
      isScrollControlled:true,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      backgroundColor: Colors.transparent,
      builder: (context){
        return NewWallet();
    }
  );
}

class NewWallet extends StatefulWidget {
  @override
  _NewWalletState createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> with TickerProviderStateMixin{
  int currentview = 0;
  List<Widget> pages;
  var qrText = "Enter your Private Key";
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result ;

  final pKeyController = TextEditingController();
  final walletName = TextEditingController();
  @override
  void initState(){
    pages = [
      newWalletPage(),
      createNewWalletPage(),
      importWalletPage()
    ];
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return pages[currentview];
  }

  


  Widget newWalletPage(){
    return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
          return Container(
            height: 900,
            color: Colors.transparent,
            child: Container(
              decoration: new BoxDecoration(
                color: bussiness,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom:40.0,left: 30.0,right: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StickBar(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset('assets/secure.png',width: 200,height: 200,),
                              ),
                              Column(
                                children: [
                                  Text("Private and Secure",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                  Text("Private keys never leave your device.",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ]
                    ),
                    Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text("Create New Wallet",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                                  )
                                ),
                                onTap:(){
                                  setState(() {
                                    currentview = 1;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: new BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text("Import Wallet",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                                  )
                                ),
                                onTap:(){
                                  setState(() {
                                    currentview = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                  ],
                ),
              )
            )
          
          );
        }
      );
  }
  Widget importWalletPage(){
    return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
          return Container(
            height: 900,
            color: Colors.transparent,
            child: Container(
              decoration: new BoxDecoration(
                color: bussiness,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40)
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      StickBar(),
                      Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentview = 0;
                        });
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 26,),
                                  SizedBox(width: 10,),
                                  Text("Back",style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.start,)
                                ],
                              ),
                              GestureDetector(
                                child: Icon(Icons.qr_code_scanner_rounded,color: Colors.white,size: 30.0,),
                                onTap: () => 
                                showModalBottomSheet(
                                  context: context, 
                                  backgroundColor: Colors.transparent,
                                  builder: (context){
                                    return new Container(
                                      color: Colors.transparent,
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: background,
                                          borderRadius: new BorderRadius.only(
                                            topLeft: const Radius.circular(40),
                                            topRight: const Radius.circular(40)
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            StickBar(),
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
                                              flex:2
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
                                                      child: Text("Place qr code of private key inside the frame \nplease avaoid shake to get result quickly",textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 14))),
                                                  ),
                                                ),
                                                
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    );
                                  }
                                )
                              )
                            ],
                          ),
                      ),
                    ),
                  ),
                  //privatekey textarea
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Column(
                      children: <Widget>[
                          TextField(
                            controller: pKeyController,
                            expands: false,
                            maxLines: 4,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: bussiness2,
                              filled: true,
                              hintText: "Private key",
                              hintStyle: TextStyle(color: Colors.white),
                              
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 4),
                            child: Text("Enter your private key as hex form or just simple write your security pharese",style: TextStyle(color: Colors.white),),
                          )
                      ],
                    ),
                  ),
                  //wallet name assign textarea
                  Padding(
                    padding: const EdgeInsets.only(top:50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          TextField(
                            controller: walletName,
                            expands: false,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: bussiness2,
                              filled: true,
                              hintText: "Wallet Name",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10.0,top: 4),
                            child: Text("Assign a name to this wallet.",style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
                          )
                      ],
                    ),
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child : GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity * 0.6,
                                    decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: new BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Center(
                                      child: Center(child: Text("IMPORT",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
                                    )
                                  ),
                                ),
                                onTap:(){
                                  checkName(walletName.text,pKeyController.text);
                                },
                              ),
                      
                    ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: bussiness2,
                    child: Padding(
                      padding: EdgeInsets.only(top:20),
                      child: Text("How to find private key?",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                    ),
                  )
                ],
              ),
            )
          );
          }
    );
  }
  Widget createNewWalletPage(){
    TextEditingController placeHolderController = new TextEditingController();
    return DraggableScrollableSheet(
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  height: 900,
                  color: Colors.transparent,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: bussiness,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40),
                        topRight: const Radius.circular(40)
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            StickBar(),
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 30.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentview = 0;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 26,),
                                            SizedBox(width: 10,),
                                            Text("Back",style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.start,)
                                          ],
                                        ),
                                      ]
                                  )
                                )
                              )
                            ),
                            SizedBox(height: 50,),
                            Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    
                                    Icon(Icons.notification_important_rounded,color: Colors.white,size: 40,),
                                    Padding(
                                      padding: const EdgeInsets.only(left:30.0,right:30,top:10),
                                    
                                      child: Text("You want to note your private address. After creation of wallet, it will store in your device and it will not share in any way. Just keep your private address safe and secure for further process.",style: TextStyle(color: Colors.white),),
                                    )
                                  ],
                                ),
                            ),
                            SizedBox(height: 40,),
                            GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Text("Create New Wallet",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                                  )
                                ),
                                onTap:(){
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
                                                          checkWalletName(context,placeHolderController.text);
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
                          ]
                        )
                      ]
                    )
                  )
                );
              }
            );
  }
  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        result = scanData;
        controller?.pauseCamera();
        print(result.code);
        qrText = result.code;
        pKeyController.text = result.code;
        Navigator.pop(context);
      });
    });
  }

  //checking wallet name is avaible or not
  checkName(name,privateKey) async{
    final database = openDatabase(Path.join(await getDatabasesPath(), 'saved_wallets.db'),);
    usedName(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Failed!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("Wallet name already in use. Type different name.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.red
      );
    };
    Future<List<Wallets>> nameChecking() async {
      final db = await database;
      bool nameOk = true;
      final List<Map<String, dynamic>> maps = await db.query('wallets');
      List.generate(maps.length, (i) {
        Wallets checkNamePlace = Wallets(name: maps[i]['name']);
        String checkName = maps[i]['name'];
        if(name == checkName){
          nameOk = false;
        }else{
          nameOk = true;
        }
        return checkNamePlace;
        }
      );
      //if name already in database 
      if(!nameOk){
        return usedName();
      }else{
        return checkPrivateKey(name,privateKey);
      }
    }
    nameChecking();
  }
  //checking wallet already added or not
  checkPrivateKey(name,privateKey) async{
    final database = openDatabase(Path.join(await getDatabasesPath(), 'saved_wallets.db'),);
    usedWallet(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Failed!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("This address already exists in your wallet.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.red
      );
    };
    Future<List<Wallets>> walletChecking() async {
      final db = await database;
      bool walletOk = true;
      final List<Map<String, dynamic>> maps = await db.query('wallets');
      List.generate(maps.length, (i) {
        Wallets checkNamePlace = Wallets(name: maps[i]['privateKey']);
        String checkPk = maps[i]['privateKey'];
        if(privateKey == checkPk){
          walletOk = false;
        }else{
          walletOk = true;
        }
        return checkNamePlace;
        }
      );
      //if name already in database 
      if(!walletOk){
        return usedWallet();
      }else{
        final publicKey = findPublicKey(privateKey);
        return addWallet(name, privateKey,publicKey);
      }
    }
    walletChecking();
  }
  
  //to find publickey from privatekey
  findPublicKey(private){
    final privateKey = PrivateKey.fromHex(private);
    final public = privateKey.publicKey;
    return public.toHex();
  }
  //After all save wallet to storage
  addWallet(name,privateKey,publicKey) async{

    success(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Success!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("Wallet added to your list.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.green
      );
    };



    final database = openDatabase(Path.join(await getDatabasesPath(), 'saved_wallets.db'),);
    //final private = PrivateKey.fromHex('dba8a45a821b65cc78a28d81b22c61829d03c973ade1ba7ee035de67714d1b75');
    var newWallet = Wallets(
      name: name,
      privateKey: privateKey,
      publicKey: publicKey,
    );
    Future<void> insertWallet(Wallets wallet) async{
      final db = await database;
      await db.insert(
        'wallets',
        wallet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await insertWallet(newWallet);
    //print(findPublicKey(private));
    Future<List<Wallets>> readWallets() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wallets');

    return List.generate(maps.length, (i){
      return Wallets(
        name: maps[i]['name'],
        privateKey:maps[i]['privateKey'],
        publicKey: maps[i]['publicKey']
      );
    });
    }
    success();
    setState(() {
      currentview = 0;
      Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()));

    });
  }
  
  





  @override
  void dispose(){
    controller.dispose();
    Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()));
    super.dispose();
  }
}

