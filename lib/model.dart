import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider.internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider.internal();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "servico.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE servico (id INTEGER PRIMARY KEY, nome TEXT, descricao TEXT,"
          "valor REAL, horario TEXT, categoria TEXT, contato TEXT)");
    });
  }

  Future<Service> saveService(Service service) async {
    Database? dbService = await db;
    service.id = await dbService.insert("servico", service.toMap());
    return service;
  }

  Future<Service?> getService(int id) async {
    Database? dbService = await db;
    List<Map> maps = await dbService.query("servico",
        columns: ["id", "nome", "descricao", "valor", "horario", "categoria", "contato"],
        where: "id = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Service.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteService(int id) async {
    Database? dbService = await db;
    return await dbService
        .delete("servico", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateService(Service service) async {
    Database dbService = await db;
    return await dbService.update("servico", service.toMap(),
        where: "id = ?", whereArgs: [service.id]);
  }

  Future<List> getAllServices() async {
    Database? dbService = await db;
    List listMap = await dbService.rawQuery("SELECT * FROM servico");
    List<Service> listService = [];
    for (Map m in listMap) {
      listService.add(Service.fromMap(m));
    }
    return listService;
  }
}

class Service {
  int? id;
  String? nome;
  String? descricao;
  double? valor;
  String? horario;
  String? categoria;
  String? contato;

  Service(this.id, this.nome, this.descricao, this.valor, this.horario, this.categoria, this.contato);

  Service.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    descricao = map["descricao"];
    valor = map["valor"];
    horario = map["horario"];
    categoria = map["categoria"];
    contato = map["contato"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "descricao": descricao,
      "valor": valor,
      "horario": horario,
      "categoria": categoria,
      "contato": contato
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
