import 'package:beChain/wallet/storage/modals/auth.dart';
import 'package:flutter/material.dart';
import 'package:beChain/wallet/card/card_wheel.dart';
import 'package:beChain/wallet/bottomBar/bottom_bar.dart';
import 'package:beChain/wallet/appBar/app_bar.dart';
import 'package:beChain/wallet/logIn/login_pop_up.dart';
import 'package:beChain/wallet/sideMenu/side_bar.dart';
import 'package:beChain/wallet/storage/modals/auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'package:beChain/wallet/wallet_page.dart';
import 'package:beChain/wallet/storage/modals/wallets.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';
import 'package:beChain/wallet/storage/modals/auth.dart';


class WalletPage extends StatefulWidget{
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>{


  
  
  @override
  void initState()  {
    
    super.initState();
    readAuth();
  }
  bool auth = false;
  String authkey;
  Future<void> readAuth() async{
        final database = openDatabase(p.join(await getDatabasesPath(), 'saved_wallets.db'),version: 1,);
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('auth');
          return List.generate(1, (i){
            print(maps.length);
            if (maps[i]['id'] != null){
              authkey = maps[i]['id'];
              auth = true;
            }
            return Auth(
              id: maps[i]['id']
            );
          });
      }
  /*
  void changeAuth(){
    setState(() {
      auth = true;
    });
  }
  */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readAuth(),
      builder: (context,snapshot) {
        return new Scaffold(
          drawer: !auth ? LogInPage() : SideMenu(),
          appBar: WalletAppBar(authKey: auth),
          body: Padding(
            padding: const EdgeInsets.only(left:20,right:20),
            child: Cards()
          ),
        );
      }
    ) ;
  }
}