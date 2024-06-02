import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('Users', row);
  }

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Tasks (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      sobrenome TEXT NOT NULL,
      telefone TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      senha TEXT NOT NULL,
      role TEXT
    )
  ''');
  }

  // Método para buscar um usuário pelo ID
  Future<Map?> getUserById(int id) async {
    Database db = await instance.database;
    List<Map> maps = await db.query('Users',
        columns: [
          'id',
          'nome',
          'sobrenome',
          'telefone',
          'email',
          'senha',
          'role'
        ],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Método para buscar todos os usuários
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('Users');
    return result;
  }

  // Método para atualizar um usuário
  Future<int> updateUser(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update('Users', row, where: 'id = ?', whereArgs: [id]);
  }

  // Método para deletar um usuário
  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> verifyUser(String email, String senha) async {
    Database db = await instance.database;
    List<Map> results = await db.query('Users',
        where: 'email = ? AND senha = ?', whereArgs: [email, senha]);
    return results.isNotEmpty;
  }

  Future<int?> getUserIdByEmail(String email) async {
    Database db = await instance.database;
    List<Map> results = await db.query(
      'Users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return results.first['id'] as int?;
    }
    return null;
  }

  Future<String?> getUserRoleById(int? userId) async {
    Database db = await instance.database;
    List<Map> results = await db.query(
      'Users',
      columns: ['role'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (results.isNotEmpty) {
      return results.first['role'] as String?;
    }
    return null;
  }
}
