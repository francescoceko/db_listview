

import 'package:db_listview/database/bo/Item.dart';
import 'package:db_listview/database/DBProvider.dart';
import 'package:sqflite/sqflite.dart';


class ItemDao{

  static const String TABLE_NAME = "ITEM";

  static Future<List<Item>> queryAllRows() async {
    Database db = await DBProvider.db.database;
    return (await db.query(TABLE_NAME)).map((element ) => Item(element["ItemId"], element["ItemVariant"], element["Barcode"],  element ["ItemDesc"])).toList();
  }

  static Future<List<Item>> queryFilterRows(String filter) async {
    if(filter == null || filter.isEmpty){
      return queryAllRows();
    }
    Database db = await DBProvider.db.database;
    return (await db.query(TABLE_NAME, where: 'ItemId like \'%$filter%\' or Barcode like \'%$filter%\' OR ItemDesc like \'%$filter%\''))
        .map((element ) => Item(element["ItemId"], element["ItemVariant"], element["Barcode"],  element ["ItemDesc"])).toList();
  }
}
