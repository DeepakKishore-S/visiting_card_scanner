import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Helper class to manage the SQLite database in singleton pattern
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;


  DatabaseHelper._internal();

  // Getter for the database; initializes it if not already done
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(); 
    return _database!;
  }

  // Initializes and opens the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory(); 
    String path = join(documentsDirectory.path, 'cards.db'); 
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, 
    );
  }

  // Function to create the 'cards' table in the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        details TEXT,
        name TEXT
      )
    '''); 
  }

  // Function to insert a new card into the 'cards' table
  Future<void> insertCard(Map<String, dynamic> card) async {
    final db = await database; 
    await db.insert('cards', card); 
  }

  // Function to delete a card from the 'cards' table by its ID
  Future<void> deleteCard(String id) async {
    final db = await database; 
    await db.delete('cards', where: 'id = ?', whereArgs: [id]); 
  }

  // Function to fetch all cards from the 'cards' table
  Future<List<Map<String, dynamic>>> fetchCards() async {
    final db = await database; 
    return await db.query('cards'); 
  }
}
