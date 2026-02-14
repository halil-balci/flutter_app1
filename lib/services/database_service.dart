import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/calculation_input.dart';
import '../models/calculation_result.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

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

  Future<int> saveCalculation(
    CalculationResult result,
    CalculationInput input,
  ) async {
    final db = await database;

    final data = {
      'netProfit': result.netProfit,
      'totalRevenue': result.totalRevenue,
      'totalCosts': result.totalCosts,
      'breakdown': _breakdownToString(result.breakdown),
      'timestamp': result.timestamp.millisecondsSinceEpoch,
      'inputData': jsonEncode(input.toMap()),
    };

    return await db.insert('calculations', data);
  }

  String _breakdownToString(Map<String, double> breakdown) {
    final entries = breakdown.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    return entries;
  }

  Map<String, double> _breakdownFromString(String breakdownStr) {
    if (breakdownStr.isEmpty) return {};
    final map = <String, double>{};
    final pairs = breakdownStr.split(',');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    return map;
  }

  Future<List<CalculationResult>> getHistory() async {
    final db = await database;

    final result = await db.query('calculations', orderBy: 'timestamp DESC');

    return result.map((map) => CalculationResult.fromMap(map)).toList();
  }

  Future<CalculationResult?> getCalculationById(int id) async {
    final db = await database;

    final result = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return CalculationResult.fromMap(result.first);
  }

  Future<CalculationInput?> getInputById(int id) async {
    final db = await database;

    final result = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final inputDataStr = result.first['inputData'] as String;
    final inputData = jsonDecode(inputDataStr) as Map<String, dynamic>;
    return CalculationInput.fromMap(inputData);
  }

  Future<int> deleteCalculation(int id) async {
    final db = await database;

    return await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearHistory() async {
    final db = await database;
    return await db.delete('calculations');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
