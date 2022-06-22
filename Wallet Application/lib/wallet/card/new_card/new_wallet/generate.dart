import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/style/style.dart';

import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:beChain/wallet/wallet_page.dart';

void generateWallet(context,name,priv,public) async{
  final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'),);
    var newWallet = Wallets(
      name: name,
      privateKey: priv,
      publicKey: public,
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
    Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> new WalletPage()));

}
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
    }