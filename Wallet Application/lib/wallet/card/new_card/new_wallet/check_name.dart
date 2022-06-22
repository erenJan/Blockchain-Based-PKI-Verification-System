import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beChain/wallet/storage/modals/Wallets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'wallet_genaration.dart';



  void checkWalletName(context,name) async{
    final database = openDatabase(
      join(await getDatabasesPath(), 'saved_wallets.db')
    );
    
    


    //if insert success
    void success(){
      Navigator.pop(context);
      WalletGeneration(context,name);
      
      print(name);
      
    }
    //if insert failed
    void failed(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Failed!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("This wallet name already in use.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.red
      );
    }



    //JUST FOR CHECKİNG After everthing done just delete below codes
    Future<List<Wallets>> checkWallets() async {
      // Get a reference to the database.
      final db = await database;
      int k = 0;
      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('wallets');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      List.generate(maps.length, (i) {
        String check = maps[i]['name'];
        if(check == name){
          k = 1;
        }else{
          k = 0;
        }
        }
      );
      if(k==0){
        success();
      }else{
        failed();
      }
      }
      checkWallets();
  }
  




