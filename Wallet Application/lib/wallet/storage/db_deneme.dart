import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:beChain/wallet/storage/modals/bookedWallets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'saved_wallets.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        '''
        CREATE TABLE bookedWallets( 
          name TEXT, 
          signature TEXT
          )''',
      );
    },
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(BookedWallet wallet) async {
    final db = await database;
    await db.insert(
      'bookedWallets',
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<BookedWallet>> bookedWallets() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('bookedWallets');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return BookedWallet(
        name: maps[i]['name'],
        signature: maps[i]['signature'],
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

  // Create a Dog and add it to the dogs table
  var fido = BookedWallet(
    name: 'Erencan Erel',
    signature: '0x313131313131313131313131',
  );

  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await bookedWallets()); // Prints a list that include Fido.

}

