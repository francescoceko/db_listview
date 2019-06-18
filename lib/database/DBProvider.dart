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
    String path = join(documentsDirectory.path, "ItemTestDB2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE ITEM ("
              "ItemId TEXT ,"
              "ItemVariant TEXT,"
              "Barcode TEXT,"
              "ItemDesc TEXT,"
              "PRIMARY KEY (ItemId, ItemVariant)"
              ")");

          await db.execute("CREATE TABLE ORDER_HEADER("
              "DocId TEXT ,"
              "DocType TEXT,"
              "DocDate TEXT,"
              "DocStatus TEXT,"
              "PRIMARY KEY (DocId)"
              ")");

          await db.execute("CREATE TABLE ORDER_ROW("
              "RowDocId TEXT ,"
              "HeaderDocId TEXT,"
              "RowDate TEXT,"
              "Quantity REAL,"
              "PRIMARY KEY (RowDocId)"
              ")");
          insertItems(100);
        });
  }

  void insertItems(int num) async {
    String qry =
        "INSERT OR REPLACE INTO ITEM (ItemId, ItemVariant, Barcode, ItemDesc) VALUES ";
    for (var i = 0; i < num; i++) {
      qry += "('IT00$i','1','800123456$i', 'Desc item $i'),";
    }
    qry = qry.substring(0, qry.length - 1);
    debugPrint("QUERY: $qry");
    final db = await database;
    db.rawInsert(qry);
  }
}