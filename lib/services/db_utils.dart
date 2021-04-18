import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;


class DBUtil {
  static Future<sql.Database> database ()async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'todo.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE IF NOT EXIST todos (id TEXT PRIMARY KEY, title TEXT, isDone BOOLEAN)');
      },
      version: 1,
    );
  }
  
  static Future<void> insert (String table, Map<String, dynamic> dados) async {
    final db = await DBUtil.database();
    await db.insert(table, dados, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future <List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBUtil.database();
    return db.query(table);
  }

  static Future<int> delete(String table, String where, List args) async {
    final db = await DBUtil.database();
    print('delete');
    return db.delete(table, where: '$where = ?', whereArgs: args);    
  }

  static Future dropTable(String table) async{
    final db = await DBUtil.database();
    await db.execute("DROP TABLE IF EXISTS $table");
  }

  static Future deleteAllFromTable(String table) async{
    final db = await DBUtil.database();
    await db.execute("DELETE FROM $table");
  }

  static Future doneUpdate(String table, String id, bool isDone) async {
    print('doneUpdate');
    final newIsDone = isDone ? 0 : 1;
    print(newIsDone);
    final db = await DBUtil.database();
    await db.execute("UPDATE $table SET isDone =  ? WHERE id = ?", [newIsDone, id]);
    print("UPDATE $table SET isDone =  $newIsDone WHERE id = $id");
  }

  static Future<List<Map<String, dynamic>>> executeSQL(String sql) async{
    final db = await DBUtil.database();
    return db.rawQuery(sql);
  }
}