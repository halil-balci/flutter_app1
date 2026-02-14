import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/calculation_input_model.dart';
import '../models/calculation_result_model.dart';

class CalculationLocalDataSource {
  static final CalculationLocalDataSource instance =
      CalculationLocalDataSource._init();
  static Database? _database;

  CalculationLocalDataSource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('calculations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        netProfit REAL NOT NULL,
        totalRevenue REAL NOT NULL,
        totalCosts REAL NOT NULL,
        breakdown TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        inputData TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCalculation(
    CalculationResultModel result,
    CalculationInputModel input,
  ) async {
    final db = await database;
    final data = result.toMap();
    data.remove('id');
    data['inputData'] = jsonEncode(input.toMap());
    return await db.insert('calculations', data);
  }

  Future<List<CalculationResultModel>> fetchHistory() async {
    final db = await database;
    final result = await db.query('calculations', orderBy: 'timestamp DESC');
    return result.map((map) => CalculationResultModel.fromMap(map)).toList();
  }

  Future<CalculationResultModel?> fetchById(int id) async {
    final db = await database;
    final result = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return CalculationResultModel.fromMap(result.first);
  }

  Future<CalculationInputModel?> fetchInputById(int id) async {
    final db = await database;
    final result = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    final inputDataStr = result.first['inputData'] as String;
    final inputData = jsonDecode(inputDataStr) as Map<String, dynamic>;
    return CalculationInputModel.fromMap(inputData);
  }

  Future<int> removeCalculation(int id) async {
    final db = await database;
    return await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removeAll() async {
    final db = await database;
    return await db.delete('calculations');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
