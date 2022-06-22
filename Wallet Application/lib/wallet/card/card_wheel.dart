import 'package:beChain/wallet/card/new_card/add_pop_up.dart';
import 'package:beChain/wallet/storage/dataBaseHelper.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'package:beChain/wallet/card/new_card/newCard.dart';
import 'package:beChain/wallet/card/new_card/walletInfo/info_pop_up.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;








class Cards extends StatefulWidget {


  @override
  State<Cards> createState() => _CardsState();

}
class _CardsState extends State<Cards> {

  Future<List> walletList;
  List walletBookedList;
  List<Wallets> walletListFinal = [];
  List<Wallets> reversedWalletListFinal = [];
  List balances;
  

  int balance;
  int selectedItem = 0;
  bool verified = false;
  int worth = 0;
  get_verified(walletAddress) async{
    bool verifiedR = false;
    //$walletAddress
  var url = Uri.parse('https://a5aa-176-90-205-154.eu.ngrok.io/findbywalletid/$walletAddress');
  var response = await http.get(
    url,
    headers: {"Content-Type":"application/json"},
  ).then((response){
    print(response.body);
    if(response.statusCode == 200){
      if(response.body == 'true'){
        verifiedR = true;
      }
    }
    setState(() {
      verified = verifiedR;
    });
    
  });
  return await verified;
}

    getHttpRq(publicKey) async{
        var temp;
        //ip
        var url = Uri.parse('http://10.2.176.42:3000/api/search-balance');
        var response = await http.post(
          url,
          headers: {"Content-Type":"application/json"},
          encoding: Encoding.getByName("utf-8"),
          body:jsonEncode({"address":"$publicKey"})
        ).then((response){
          var result = json.decode(response.body);
          
          temp = result["balance"];
          
        });
        setState(() {
          balance = temp;
        });
        // ignore: await_only_futures
        worth = await getHttpRq(publicKey);
        return balance;
    }

  

  void selection(selectedItem){
    if (selectedItem == reversedWalletListFinal.length-1) {
      addWalletPopUp(context);
    }else{
      walletInfoPooUp(context,selectedItem);
    }
  }

  @override
  void initState() {

    balance = 0;
    
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
            walletListFinal.add(walletBookedList[i]);
          }
        });
        reversedWalletListFinal = walletListFinal.reversed.toList();
    }
    
    getWallets();
    super.initState();
  }

   get_balance(key) async{
      await getHttpRq(key).then((value){
      setState(() {
        this.balance = value;
      });
      print(balance);
      return value;
    });
  }
  int count = 0;
  
  get_verifiedR(key) async{
      if(count<5){
        await get_verified(key).then((value){
        setState(() {
          this.verified = value;
        });
        print(this.verified);
        return value;
      });
      }
      count++;
  }
 
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      
      child: ListWheelScrollView(
        
        onSelectedItemChanged: (index) => selectedItem = index,
        itemExtent: 200,

        children: reversedWalletListFinal.map((wallet) => Column(
                children: [
                  if (wallet.name == "add_new_card") ...[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: NewCard(),
                    )
                  ] else...[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(wallet.name,textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 40.0),),
                                  Text("${ get_verifiedR(wallet.publicKey)}",style: TextStyle(color: Colors.transparent,fontWeight: FontWeight.bold,fontSize: 0),),
                                  verified ? Icon(Icons.verified_outlined,color: Colors.white,size: 60.0,):Icon(Icons.warning_amber_rounded ,color: Colors.red,size: 60.0,),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(Radius.circular(90)),
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                    Text("${ get_balance(wallet.publicKey)}",style: TextStyle(color: Colors.transparent,fontWeight: FontWeight.bold,fontSize: 0),),
                                    Text("$balance BeChain",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(wallet.publicKey,style: TextStyle(color: Colors.white,fontSize: 12),),
                                )
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
        )).toList()
      ),
      onTap: () => selection(selectedItem),
    );
  }
}