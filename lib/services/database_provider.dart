import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/service.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDb();
      return _db!;
    }
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "Tarefa.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE servico (id INTEGER PRIMARY KEY, nome TEXT, descricao TEXT,"
          "valor REAL, horario TEXT, categoria TEXT)");
    });
  }

  Future<Service> saveService(Service service) async {
    Database? dbService = await db;
    service.id = await dbService.insert("servico", service.toMap());
    return service;
  }

  Future<Service?> getService(int id) async {
    Database? dbService = await db;
    List<Map<String, dynamic>> maps = await dbService.query("servico",
        columns: ["id", "nome", "descricao", "valor", "horario", "categoria"],
        where: "id = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Service.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteService(int id) async {
    Database? dbService = await db;
    return await dbService.delete("servico", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateService(Service service) async {
    Database dbService = await db;
    return await dbService.update("servico", service.toMap(),
        where: "id = ?", whereArgs: [service.id]);
  }

  Future<List<Service>> getAllServices() async {
    Database? dbService = await db;
    List<Map<String, dynamic>> listMap =
        await dbService.rawQuery("SELECT * FROM servico");
    List<Service> listService = [];
    for (Map<String, dynamic> m in listMap) {
      listService.add(Service.fromMap(m));
    }
    return listService;
  }
}
