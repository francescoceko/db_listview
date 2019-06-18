import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


 class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;


  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ItemTestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE ITEM ("
              "ItemId TEXT ,"
              "ItemVariant TEXT,"
              "Barcode TEXT,"
              "ItemDesc TEXT,"
              "PRIMARY KEY (ItemId, ItemVariant)"
              ")");
          insertItems(50);
        });
  }

  void insertItems(int num) async {
    String qry =
        "INSERT OR REPLACE INTO ITEM (ItemId, ItemVariant, Barcode, ItemDesc) VALUES ";
    for (var i = 0; i < num; i++) {
      qry += "('$i','1','800123456$i', 'Item $i'),";
    }
    qry = qry.substring(0, qry.length - 1);
    debugPrint("QUERY: $qry");
    final db = await database;
    db.rawInsert(qry);
  }
}