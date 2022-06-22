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

import 'wallet/storage/modals/auth.dart';
Color background = Color.fromRGBO(20, 20, 21, 1);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    p.join(await getDatabasesPath(), 'saved_wallets.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute("CREATE TABLE bookedWallets(name TEXT,signature Text);CREATE TABLE wallets(name TEXT,privateKey TEXT,publicKey TEXT);CREATE TABLE auth(id)");
    },
    version: 1,
    
  );

  /*
  Future<void> clearDB() async{
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS bookedWallets");
    await db.execute("DROP TABLE IF EXISTS wallets");
    await db.execute("CREATE TABLE bookedWallets(name TEXT,signature Text)");
    await db.execute("CREATE TABLE wallets(name TEXT,privateKey TEXT,publicKey TEXT)");
    await db.execute("CREATE TABLE auth(id)");
  }
  clearDB();
  */

  Future<void> add() async{
    final db = await database;
    await db.execute("INSERT INTO wallets(name,privateKey,publicKey) VALUES('add_new_card',null,null)");
  }
  //add();
  

  // Define a function that inserts bookedWallet into the database
  Future<void> insertBookedWallet(BookedWallet wallet) async {
    final db = await database;
    await db.insert(
      'bookedWallets',
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that insets new wallet into database
  Future<void> insertWallet(Wallets wallet) async{
    final db = await database;
    await db.insert(
      'wallets',
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


 

  // A method that retrieves all the bookedWallets from the bookedWallets table.
  Future<List<BookedWallet>> bookedWallets() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('bookedWallets');

    return List.generate(maps.length, (i) {
      return BookedWallet(
        name: maps[i]['name'],
        signature: maps[i]['signature'],
      );
    });
  }

  // A method that retrieves all the wallets from wallets table
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
    Future<List<Auth>> readAuth() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('auth');
  print("a");
    return List.generate(maps.length, (i){
      print(maps.length);
      return Auth(
        id: maps[i]['id']
      );
    });
  }

  //no update function here!!

  Future<void> deleteBookedWallet(String signature) async {
    final db = await database;
    // Remove the Dog from the database.
    await db.delete(
      'bookedWallets',
      // Use a `where` clause to delete a specific dog.
      where: 'signature = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [signature],
    );
  }
  
  

  // Now, use the method above to retrieve all the dogs.
  print(await readAuth());
  print(await readWallets());
  print(await bookedWallets());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: background,
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.auto
          )
        ),
        home: WalletPage(),
      ),
    );
  }
}