import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/modelo_principal.dart';

class DatabaseHelper {
  static const _dbName = 'atividades.db';
  static const _tableName = 'atividades';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        duracao_minutos INTEGER NOT NULL,
        calorias INTEGER NOT NULL,
        intensidade TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  Future<List<Atividade>> listar() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map(Atividade.fromMap).toList();
  }

  Future<Atividade> inserir(Atividade atividade) async {
    final db = await database;
    final id = await db.insert(_tableName, atividade.toMap()..remove('id'));
    return atividade.copyWith(id: id);
  }

  Future<Atividade> atualizar(Atividade atividade) async {
    if (atividade.id == null) {
      throw ArgumentError('Atividade precisa de id para atualização local.');
    }

    final db = await database;
    await db.update(
      _tableName,
      atividade.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [atividade.id],
    );
    return atividade;
  }

  Future<void> deletar(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
