import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHandler {

  DataBaseHandler._privateConstructor();
  static final DataBaseHandler instance = DataBaseHandler._privateConstructor();

  Future<Database> initializedDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path,'bechain.db'),
      onCreate:(database,version) async{
        await database.execute("CREATE TABLE bookedWallets(id INTEGER PRIMARY KEY,signature TEXT NOT NULL,name TEXT NOT NULL)");
      },
      version: 1,
    );
  }

  Future<int>insertBookedWallet(List<BookedWallet> BookedWallet) async{
    int result = 0;
    final Database db = await initializedDB();
    for(var booked in BookedWallet){
      result = await db.insert('bookedWallets', booked.toMap());
    }
    return result;
  }

  Future<List<BookedWallet>> retrieveBookedWallets() async{
    final Database db = await initializedDB();
    final List<Map<String,Object>> queryResult = await db.query('bookedWallets');
    return queryResult.map((e)=>BookedWallet.fromMap(e)).toList();
  }

  Future<void> deleteBookedWallet(String signature) async{
    final db = await initializedDB();
    await db.delete(
      'bookedWallets',
      where: 'signature = ?',
      whereArgs: [signature]
    );
  }
}

class BookedWallet {
  final int id;
  final String signature;
  final String name;

  BookedWallet({this.id,this.signature,this.name});

  factory BookedWallet.fromMap(Map<String,dynamic> res) => new BookedWallet(
    signature : res['signature'],
    name : res['name']
  );

  Map<String,Object> toMap(){
    return {
      'signature': signature,
      'name': name,
    };
  }

}