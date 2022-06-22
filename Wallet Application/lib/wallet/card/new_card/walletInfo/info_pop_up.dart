// ignore_for_file: deprecated_member_use

import 'dart:ffi';
import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:http/http.dart' as http;

import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/certificate_page/certificiate_pop_up.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/visual/stickbar.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beChain/wallet/storage/modals/auth.dart';

import 'package:beChain/wallet/wallet_page.dart';

void walletInfoPooUp(context, selectedItem) async{
  var worth;
  List walletBookedList;
  List<Wallets> walletListFinal = [];
  var walletAddress;
  var walletName;
  bool verified = false;
  bool kyc = false;
  String id;
  /*
  get_verified(context,walletAddress) async{
  var url = Uri.parse('https://f8c4-176-90-205-154.eu.ngrok.io/auth');
  var response = await http.post(
    url,
    headers: {"Content-Type":"application/json"},
    encoding: Encoding.getByName("utf-8"),
    body:jsonEncode({'walletAddress': '$walletAddress'})
  ).then((response){
    if(response.statusCode == 200){
      if(response.body == true){
        verified = false;
      }
    }
    
  });
}
*/


  void getWallets() async{
      Future<List<Wallets>> readWallets() async{
        final database = openDatabase(
          p.join(await getDatabasesPath(), 'saved_wallets.db'),
          version: 1,
          
        );

        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('wallets');

        return List.generate(maps.length, (i){
          return Wallets(
            name: maps[i]['name'],
            privateKey:maps[i]['privateKey'],
            publicKey: maps[i]['publicKey']
          );
        }
        );
      }
      walletBookedList = await readWallets();
        
          for(var i = 0; i<walletBookedList.length;i++){
            walletListFinal.add(walletBookedList[i]);
          }
        var reversedWalletListFinal = walletListFinal.reversed.toList();
        walletAddress = reversedWalletListFinal[selectedItem].publicKey;
        walletName = reversedWalletListFinal[selectedItem].name;
        print(reversedWalletListFinal[selectedItem]);
        
    }
    getWallets();
  
  get_verified(walletAddress) async{
    //$walletAddress
  var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/findbywalletid/$walletAddress');
  var response = await http.get(
    url,
    headers: {"Content-Type":"application/json"},
  ).then((response){
    print("deneme1");
    print(response.body.runtimeType);
    if(response.statusCode == 200){
      if(response.body == 'true'){
        verified = true;
      }
    }
    
  });
}
Future<List<Auth>> readAuth() async{
      final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'));
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('auth');
    print("a");
      return List.generate(maps.length, (i){
        print(maps.length);
        id = maps[i]['id'];
        return Auth(
          id: maps[i]['id']
        );
      });
    }
    await readAuth();
  get_kyc(id) async{
    //id
    var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/checkkycwithid/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type":"application/json"},
    ).then((response){
      print("deneme1");
      print(response.body.runtimeType);
      print(response.body);
      if(response.statusCode == 200){
        if(response.body == 'true'){
          kyc = true;
          print(kyc);
        }
      }
      
    });
  }
  await get_kyc(id);
  await get_verified(walletAddress);
  
  getHttpRq(context,walletAddress) async{
      var temp;
      var url = Uri.parse('http://10.2.176.42:3000/api/search-balance');
      var response = await http.post(
        url,
        headers: {"Content-Type":"application/json"},
        encoding: Encoding.getByName("utf-8"),
        body:jsonEncode({"address":"$walletAddress"})
      ).then((response){
        
        var result = json.decode(response.body);
        
        temp = result["balance"];
        
      });
      print(temp);
      return await temp;
      
  }

  worth = await getHttpRq(context,walletAddress);

  showModalBottomSheet(
      isScrollControlled:true,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      backgroundColor: Colors.transparent,
      builder: (context){
        return WalletInfo(worth:worth,id:id,walletAddress:walletAddress,walletName:walletName,verified: verified,kyc: kyc);
    }
  );
}


class WalletInfo extends StatefulWidget {
 

  final int worth;
  final int selectedItem;
  final String walletName;
  final String walletAddress;
  final bool verified;
  final bool kyc;
  final String id;
  const WalletInfo ({ Key key, this.worth ,this.selectedItem,this.id,this.walletAddress,this.walletName,this.verified,this.kyc}): super(key: key);
  @override
  State<WalletInfo> createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfo> with TickerProviderStateMixin {
  var walletAddress;
  var currentView = 0;
  var balance;
  List<Widget> pages;
  Future<List> bookedWalletList;
  List bookedList;
  List<String> bookedListFinal = [];
  TabController _tabController;
  TabController _secondTabController;
  TabController _thirdTabController;
  TabController _infoTabController;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result ;
  String _selected;
  TextEditingController certificateAddress = TextEditingController();
  TextEditingController certificateAmount = TextEditingController();

  TextEditingController publicAddress = TextEditingController();
  TextEditingController publicAmount = TextEditingController();

  TextEditingController knownAmount = TextEditingController();
  
  List walletBookedList;
  List<Wallets> walletListFinal = [];
  List<Wallets> reversedWalletListFinal = [];
  
  String id;
  
  void initState() {
    balance = widget.worth;
    _tabController = TabController(length: 2, vsync: this);
    _secondTabController = TabController(length: 2,vsync: this);
    _thirdTabController = TabController(length: 2,vsync: this);
    _infoTabController = TabController(length: 2,vsync: this);


    void getBookedWallet() async{
      final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'));
      Future<List<BookedWallet>> bookedWallets() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('bookedWallets');
        return List.generate(maps.length, (i) {
          return BookedWallet(
            name: maps[i]['name'],
          );
        });
      }
      bookedList = await bookedWallets();
      
      setState(() {
        for(var i = 0; i<bookedList.length;i++){
          bookedListFinal.add(bookedList[i].name);
        }
      });
    }
    
    getBookedWallet();

    
    

    pages = [
      walletSummary(widget.worth,widget.id,widget.walletAddress,widget.walletName,widget.verified,widget.kyc),
      send(),
      qr_result(),
      
    ];
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return pages[currentView];
  }

  

  //assets on wallet field
  Widget assets(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: sideBar,width: 0.6)
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:10.0,left: 10,right: 10,bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(90)),
                          color: Colors.white
                        ),
                      ),
                      SizedBox(width: 20,),
                        Text("$balance BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Text("${balance/1000} \$",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                  )
                ],
              )
            ),
          ),
        ),
      ],
    );
  }
  //transaction history
  Widget transactions(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.green,width: 0.6)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10,right: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.green
                            )
                          ),
                          child: Transform.rotate(
                            angle: 160,
                            child: Icon(Icons.trending_up_rounded,color: Colors.green,size: 30,)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("100",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                                  SizedBox(width: 10,),
                                  Text("BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                ],
                              ),
                              Text("From: Erencan Erel",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Text("30.01.2022",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    )
                  ],
                )
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.red,width: 0.6),
                bottom: BorderSide(color: Colors.red,width: 0.6)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10,right: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.red
                            )
                          ),
                          child: Transform.rotate(
                            angle: 270,
                            child: Icon(Icons.trending_up_rounded,color: Colors.red,size: 30,)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("50",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16),),
                                  SizedBox(width: 10,),
                                  Text("BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                ],
                              ),
                              Text("To: Berkay Ülgentürk",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Text("30.01.2022",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    )
                  ],
                )
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.red,width: 0.6),
                bottom: BorderSide(color: Colors.red,width: 0.6)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10,right: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.red
                            )
                          ),
                          child: Transform.rotate(
                            angle: 270,
                            child: Icon(Icons.trending_up_rounded,color: Colors.red,size: 30,)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("50",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16),),
                                  SizedBox(width: 10,),
                                  Text("BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                ],
                              ),
                              Text("To: 0x232343abf97d232d",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Text("24.01.2022",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    )
                  ],
                )
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.red,width: 0.6),
                bottom: BorderSide(color: Colors.red,width: 0.6)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10,right: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.red
                            )
                          ),
                          child: Transform.rotate(
                            angle: 270,
                            child: Icon(Icons.trending_up_rounded,color: Colors.red,size: 30,)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("50",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16),),
                                  SizedBox(width: 10,),
                                  Text("BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                ],
                              ),
                              Text("To: 0x232343abf97d232d",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:20.0),
                      child: Text("24.01.2022",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    )
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
  //walletSummary
  Widget  walletSummary(int balance,String id,String walletAddress, String walletName,bool verified,bool kyc){

    
    const List<Tab> _infoPageTabs = [
      const Tab(child: const Text('Assets')),
      const Tab( child: const Text('Transactions'))
    ];
    List<Widget> _infoPageTabView = [
      assets(),
      transactions()
    ];
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StickBar(),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(walletName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 26),),
                          Row(
                            children: [
                              Text("${walletAddress.substring(0,18)}...${walletAddress.substring(54,64)}",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w300),),
                              SizedBox(width: 10,),
                              Icon(Icons.copy,color: Colors.white,size: 16,)
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Container(
                          child: verified? Icon(Icons.verified_outlined,color: Colors.white,size: 30.0,):
                          GestureDetector(
                            child: Icon(Icons.warning_amber_rounded,color: Colors.red,size: 50.0,),
                            onTap: () =>{
                              signature_generation(context,id,walletAddress,kyc)
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              
              Center(
                child: Column(
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(90)),
                          color: Colors.white
                        ),
                    ),
                    SizedBox(height: 10,),
                    Text("${balance/1000} \$",style: TextStyle(color: Colors.white),)
                  ],
                )
              ),
              verified ?Padding(
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
                        Text("${walletAddress.substring(0,18)}...${walletAddress.substring(44,64)}",style: TextStyle(color: Colors.blueGrey,fontSize: 10),),
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
                      onTap: (){CertificatePopUp(context,walletAddress);},
                    )
                  ],
                ),
              ):SizedBox(height: 40,),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left:24.0,right: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){setState(() {
                          recieve(context);
                        });},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              
                                  Transform.rotate(angle: 90 ,child: Icon(Icons.arrow_forward,color: Colors.white,)),
                                  SizedBox(width: 10,),
                                  Text("RECIEVE",style: TextStyle(color: Colors.white,fontSize: 18),),
                                ],
                              )
                          ),
                        ),
                      )
                    ),
                    SizedBox(width: 40,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentView = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("SEND",style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(width: 10,),
                                  Transform.rotate(angle: -45 ,child: Icon(Icons.arrow_forward,color: Colors.white,))
                                ],
                              )
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Flexible(
                child: TabBar(
                  indicatorColor: Colors.blue,
                  indicatorWeight: 2,
                  controller: _infoTabController,
                  physics: BouncingScrollPhysics(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(5),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
                  tabs: _infoPageTabs,
                ),
              ),
              Container(
                height: 256,
                child: new TabBarView(
                  controller: _infoTabController,
                  children: _infoPageTabView
                ),
              )
            ], 
          ),
        );      
      }
    );
  }
  get_signature(id,walletAddress) async{
    //signature
    print("deneme");
    print(id);
    var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/users/createsignature/$id');
    var response = await http.post(
      url,
      headers: {"Content-Type":"application/json"},
      encoding: Encoding.getByName("utf-8"),
      body:jsonEncode({'wallet_id': '$walletAddress'})
    ).then((response){
      print("deneme1");
      print(response.body.runtimeType);
      print(response.body);
      if(response.statusCode == 200){
        print(response.body);
        Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()));

      }
      
    });
  }
  Future<dynamic> signature_generation(BuildContext context,id,walletAddress,kyc) {
    return showModalBottomSheet(
    context: context, 
    backgroundColor: Colors.transparent,
    builder: (BuildContext context){
      return Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
            )
          ),
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:  <Widget>[
                Text("Signature Generation",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Text("${walletAddress}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),),

                  SizedBox(height: 30,),
                  Center(
                      child: FlatButton(
                        onPressed: (){
                          if(kyc){
                            get_signature(id,walletAddress);

                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kyc ? Colors.blue :Colors.grey
                          ),
                          child: Center(
                            child: kyc ? Text("Generate",style: TextStyle(color: Colors.white),) : Text("Complete KYC",style: TextStyle(color: Colors.white),) ,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
    });
  }
  //qr scan field page
  Widget qr_send_field(){
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
                overlayColor: bussiness
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
  //certificate field 
  Widget certificate_send(){
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right: 18,top: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: certificateAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.menu_book_rounded,color: Colors.white,),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 10),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    labelText: "Certificate Address",
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: GestureDetector(
                  onTap: (){CertificatePopUp(context,walletAddress);},
                  child: Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(Icons.plagiarism_rounded,color: Colors.white,size: 36,),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: certificateAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              suffixText: 'BeChain' 
            ),
            
          ),
          SizedBox(height: 40,),
          Center(
            child: FlatButton(
              onPressed: (){sendWithCertificate(certificateAddress.text, certificateAmount.text);},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //public address field
  Widget public_address(){
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right: 18,top: 24),
      child: Column(
        children: [
          TextFormField(
            controller: publicAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.api_rounded,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Public Address Address",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          
          SizedBox(height: 20,),
          TextFormField(
            controller: publicAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              suffixText: 'BeChain' 
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: FlatButton(
              onPressed: () {
                print(bookedListFinal[0]);
              },
              //onPressed: (){sendWithPublicAddress(publicAddress.text, publicAmount.text);},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //unknown wallet field page
  Widget unkownWallet(){
    const List<Tab> _thirdTabs = [
      const Tab(icon: Icon(Icons.vpn_key_rounded), child: const Text('Public Address')),
      const Tab(icon: Icon(Icons.verified_outlined), child: const Text('Certificate'))
    ];
    List<Widget> _thirdView = [
      public_address(),
      certificate_send(),
    ];
    return Column(
        children: [
          Flexible(
            child: TabBar(
              indicatorColor: Colors.lime,
              controller: _thirdTabController,
              physics: BouncingScrollPhysics(),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(5),
              labelColor: Colors.lime,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
              tabs: _thirdTabs,
            ),
          ),
          Container(
            height: 280,
            child: new TabBarView(
              controller: _thirdTabController,
              children: _thirdView
            ),
          )
        ],
    );
  }
  //known wallet field page
  Widget kownWallet(){
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right:18.0,top:14),
      child: Column(
        children: [
          Theme(
            data: ThemeData(
              textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white)),
            ),
            child: DropdownSearch<String>(
              popupBackgroundColor: bussiness,
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15)
                ),
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.person,color: Colors.white,),
              ),
              mode: Mode.BOTTOM_SHEET,
              showSelectedItems: true,
              items: bookedListFinal,
              selectedItem: _selected,
              label: "Persons on your list",
              popupItemDisabled: (String s) => s.startsWith('I'),
              showSearchBox: true,
              onChanged: (String selected){
                _selected = selected;
              },
              emptyBuilder: (context, searchEntry) => Center(child: Text('There is no person with this name',style:TextStyle(color:Colors.white))),
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: knownAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              suffixText: 'BeChain' 
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: FlatButton(
              onPressed: (){sendWithKnown(_selected, knownAmount.text);},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //direct send field page
  Widget direct_send(){
    const List<Tab> _secondTabs = [
      const Tab(icon: Icon(Icons.person), child: const Text('Known Wallet')),
      const Tab(icon: Icon(Icons.person_off), child: const Text('Unknown wallet'))
    ];
    List<Widget> _seconView = [
      kownWallet(),
      unkownWallet(),
    ];
    return Column(
      children: [
        Flexible(
          child: TabBar(
            indicatorColor: Colors.orange,
            controller: _secondTabController,
            physics: BouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(5),
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
            tabs: _secondTabs,
          ),
        ),
        Container(
          height: 350,
          child: new TabBarView(
            controller: _secondTabController,
            children: _seconView
          ),
        )
      ],
    );
  }
  //whole send page
  Widget send(){
    const List<Tab> _tabs = [
      const Tab(icon: Icon(Icons.qr_code), child: const Text('QR Scan')),
      const Tab(icon: Icon(Icons.send), child: const Text('Send Direct'))
    ];
    List<Widget> _views = [
      qr_send_field(),
      direct_send(),
    ];
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: Column(
            children: [
              StickBar(),
              Flexible(
                child: TabBar(
                  controller: _tabController,
                  physics: BouncingScrollPhysics(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(5),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
                  tabs: _tabs,
                ),
              ),
              Container(
                  height: 420,
                  child:TabBarView(
                    controller: _tabController,
                    children: _views
                  ),
                ),
            ],
          ), 
        );
      }
    );
  }
  //send with known person
  void sendWithKnown(_selected,knownAmount){
    //if amount lower than 1 
    knownAmount = int.parse(knownAmount);
    if (knownAmount < 1){

    }else{
      //checking public address validation via async function here
      final checkAddressValidation = true;
      if(checkAddressValidation){
        setState(() {
          currentView = 0;
        });
      }
    }
  }
  //send with public address
  void sendWithPublicAddress(publicAddress,publicAmount){
    //if amount lower than 1 
    publicAmount = int.parse(publicAmount);
    if (publicAmount < 1){

    }else{
      //checking public address validation via async function here
      final checkAddressValidation = true;
      if(checkAddressValidation){
        setState(() {
          currentView = 0;
        });
      }
    }
  }
  //send with certificate
  void sendWithCertificate(certificateAddress,certificateAmount){
    //if amount lower than 1 
    certificateAmount = int.parse(certificateAmount);
    if (certificateAmount < 1){

    }else{
      //checking signature's validation via async function here
      final checkSignatureValidation = true;
      if(checkSignatureValidation){
        setState(() {
          currentView = 0;
        });
      }
    }
  }
  //qr result and payment page
  Widget qr_result(){
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          height: 900,
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: Column(
            children: [
              StickBar(),
            ]
          )
        );
      }
    ); 
  }
  
  Widget certificatedRecieve(){
    TextEditingController recieveCertificatedAmount = new TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right:18.0,top:14),
      child: Column(
        children: [
          
          SizedBox(height: 20,),
          TextFormField(
            controller: recieveCertificatedAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              suffixText: 'BeChain' 
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: FlatButton(
              onPressed: (){qr_display(widget.walletAddress, recieveCertificatedAmount.text,"certificated");},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Generate QR code",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //transaction history
  Widget uncertificated_recieve(){
    TextEditingController uncertificatedAmount = new TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right:18.0,top:14),
      child: Column(
        children: [
          
          SizedBox(height: 20,),
          TextFormField(
            controller: uncertificatedAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money,color: Colors.white,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 10),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: "Amount",
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              suffixText: 'BeChain' 
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: FlatButton(
              onPressed: (){qr_display(widget.walletAddress, uncertificatedAmount.text,"uncertificated");},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Generate QR code ",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void qr_display(walletAddress,amount,type){
    showModalBottomSheet(
      isScrollControlled:true,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      backgroundColor: Colors.transparent, 
      builder: (BuildContext context){
        return Container(
          height: 560,
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                QrImage(
                  data: '''
                    "walletAddress" : $walletAddress,
                    "amount" : $amount,
                    "type"  : $type
                  ''',
                  version: QrVersions.auto,
                  size: 400.0,
                  foregroundColor: Colors.white,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Wallet Address :",style: TextStyle(color: Colors.white),),
                          Text(walletAddress.substring(0,16)+"..."+walletAddress.substring(54,64),style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Amount :",style: TextStyle(color: Colors.white),),
                          Text(amount+" Bechain",style: TextStyle(color: Colors.white),),
                        ], 
                      ),
                      Row(
                        children: [
                          Text("Transaction Type :",style: TextStyle(color: Colors.white),),
                          Text(type,style: TextStyle(color: Colors.white),),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
  
  void recieve(context){
    const List<Tab> _recievePageTabs = [
      const Tab(child: const Text('Only Certificated')),
      const Tab( child: const Text('Every Wallet'))
    ];
    List<Widget> _recievePageTabView = [
      certificatedRecieve(),
      uncertificated_recieve()
    ];
    showModalBottomSheet(
      isScrollControlled:true,
      isDismissible: true,
      enableDrag: true,
      context: context, 
      backgroundColor: Colors.transparent,
      builder: (BuildContext context){
        return Container(
          height: 560,
          decoration: new BoxDecoration(
            color: bussiness,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40)
            ),
          ),
          child: Column(
            children: [
              StickBar(),
              SizedBox(height: 20),
              Flexible(
                child: TabBar(
                  indicatorColor: Colors.blue,
                  indicatorWeight: 2,
                  controller: _infoTabController,
                  physics: BouncingScrollPhysics(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(5),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
                  tabs: _recievePageTabs,
                ),
              ),
              Container(
                height: 400,
                child: new TabBarView(
                  controller: _infoTabController,
                  children: _recievePageTabView
                ),
              )
            ]
          )
        );
      }
    ); 
  }
  //qr scanner for qr scan field page
  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        result = scanData;
        controller?.pauseCamera();
        print(result.code);
        currentView = 2;
      });
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  
}
