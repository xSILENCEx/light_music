import 'package:sqflite/sqflite.dart';

const appDbName = "lp_db";

///数据库管理
class SqfliteHelper {
  ///初始化数据库
  static Future<void> initDB() async {
    Database _db = await openDatabase(await _getDbPath(appDbName));
    print('initDb:${_db.path}');
  }

  ///获取数据库路径
  static Future<String> _getDbPath(String dbName) async {
    final String _databasesPath = await getDatabasesPath();
    return _databasesPath + "/" + dbName + ".db";
  }

  //TODO 本地存储
}
