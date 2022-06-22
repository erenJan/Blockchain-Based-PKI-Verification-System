import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:overlay_support/overlay_support.dart';



  void BookWalletFromScan(name,signature) async{
    final database = openDatabase(
      join(await getDatabasesPath(), 'saved_wallets.db')
    );
    //insert function for adding new scanned signature address to storage
    Future<void> insertBookedWallet(BookedWallet wallet) async {
      final db = await database;
      await db.insert(
        'bookedWallets',
        wallet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    String bookedName = name;

    //create object for new booked wallet address
    var newScannedWallet = BookedWallet(
      name: name,
      signature: signature,
    );
    //insert to database


    //if insert success
    void success(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Success!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("Wallet added to your list as $bookedName.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.green
      );
    }
    //if insert failed
    void failed(){
      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Failed!",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
            Text("Wallet already in your list as $bookedName.",style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
        background: Colors.red
      );
    }



    //JUST FOR CHECKİNG After everthing done just delete below codes
    Future<List<BookedWallet>> bookedWallets() async {
      // Get a reference to the database.
      final db = await database;
      int k = 0;
      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('bookedWallets');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      List.generate(maps.length, (i) {
        BookedWallet checkSignature = BookedWallet(signature: maps[i]['signature']);
        String check = maps[i]['signature'];
        if(check == signature){
          k = 1;
          bookedName = maps[i]['name'];
        }else{
          k = 0;
        }
        return checkSignature;
        }
      );
      if(k==0){
        await insertBookedWallet(newScannedWallet);
        success();
      }else{
        failed();
      }
      }
      bookedWallets();
  }
  




