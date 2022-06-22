
import 'package:beChain/wallet/appBar/qr_scanner/result_of_scanned/visual/stickbar.dart';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:dropdown_search/dropdown_search.dart';
void recieveCertificated(context,walletAddress,amount){
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
          child: Certificated(walletAddress,amount)
        )
      );
    }
  );
}




class Certificated extends StatefulWidget {
  final walletAddress;
  final amount;
  Certificated(this.walletAddress, this.amount, {Key key}) : super(key: key);

  @override
  State<Certificated> createState() => _Certificated();
}

class _Certificated extends State<Certificated> {
  int currentView = 0;
  List<Widget> pages;
  Future<List> walletList;
  List walletBookedList;
  List<String> walletListFinal;
  String _selected;
  @override
  void initState(){
    /*
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
        
        setState(() {
          for(var i = 0; i<walletBookedList.length;i++){
            walletListFinal.add(walletBookedList[i].name);
            
          
          }
        });
    }
    */
    pages = [
      uncertificatedInfo(),
      selectWallet()
    ];
    super.initState();
  }
  
  
  Widget build(BuildContext context) {
    return pages[currentView];
    
  }

Widget uncertificatedInfo(){
  return Column(
      children: [
        StickBar(),
        Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text("Certificated Wallet generated this transaction request",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                            Icon(Icons.verified_rounded ,color: Colors.white,size: 60.0,),

                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Address",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(height: 1),
                            Text(widget.walletAddress,style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Amount",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                            Text(widget.amount,style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Text("Continue Payment",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)
                                      )
                                    ),
                                    onTap:(){
                                      setState(() {
                                        currentView = 1;
                                      });
                                    },
                                  ),
                    ],
                  )
                  ),
      ],
    );       
  
}
Widget selectWallet(){
  return Column(
    children: [
      StickBar(),
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
              items: walletListFinal,
              selectedItem: _selected,
              label: "Your Wallets",
              popupItemDisabled: (String s) => s.startsWith('I'),
              showSearchBox: true,
              onChanged: (String selected){
                _selected = selected;
              },
              emptyBuilder: (context, searchEntry) => Center(child: Text('There is no wallet to perform this transaction',style:TextStyle(color:Colors.white))),
            ),
          ),
          SizedBox(height: 100,),
          Center(
            child: FlatButton(
              onPressed: (){print(_selected);},
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
                      Text("Contunie Transaction",style: TextStyle(color: Colors.white,fontSize: 20),),
                      SizedBox(width: 20,),
                      Icon(Icons.send,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
    ],
  );
}
}