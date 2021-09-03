import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "all_Data";
final String Column_id = "id";
final String Column_name = "data";

class TaskModel {
  final String data;
  int id;

  TaskModel({this.data, this.id});

  Map<String, dynamic> toMap() {
    return {Column_name: this.data};
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "databse.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_name TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<void> delete() async {
    db.delete(tableName);
  }

  Future close() async => db.close();

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);
    return List.generate(tasks.length, (i) {
      return TaskModel(data: tasks[i][Column_name], id: tasks[i][Column_id]);
    });
  }
}
