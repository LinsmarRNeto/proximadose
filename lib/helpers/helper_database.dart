import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  // Nome do banco de dados
  static const String databaseName = 'proximadose.db';

  // Tabelas e colunas
  static const String userTable = 'user';
  static const String userIdCol = 'id';
  static const String userNameCol = 'name';
  static const String userEmailCol = 'email';
  static const String userPasswordCol = 'password';

  static const String medicineTable = 'medicine';
  static const String medicineIdCol = 'id';
  static const String medicineNameCol = 'name';
  static const String medicineDoseCol = 'dose';
  static const String medicineModeCol = 'mode';
  static const String medicineDateCol = 'date';
  static const String medicineTimeCol = 'time';
  static const String medicineStatusCol = 'status';
  static const String medicineImageCol = 'image';

  // Método para obter ou criar o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Cria as tabelas no banco de dados
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        $userIdCol INTEGER PRIMARY KEY AUTOINCREMENT,
        $userNameCol TEXT,
        $userEmailCol TEXT,
        $userPasswordCol TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $medicineTable (
        $medicineIdCol INTEGER PRIMARY KEY AUTOINCREMENT,
        $medicineNameCol TEXT,
        $medicineDoseCol TEXT,
        $medicineModeCol TEXT,
        $medicineDateCol TEXT,
        $medicineTimeCol TEXT,
        $medicineStatusCol INTEGER,
        $medicineImageCol TEXT
      )
    ''');
  }

  // CRUD para a tabela de usuário

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(userTable, user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query(userTable);
  }

  // Adiciona o método para verificar login
  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      userTable,
      where: '$userEmailCol = ? AND $userPasswordCol = ?',
      whereArgs: [email, password],
    );
    return users.isNotEmpty ? users.first : null;
  }

// Adiciona o método para verificar se o email existe
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      userTable,
      where: '$userEmailCol = ?',
      whereArgs: [email],
    );
    return users.isNotEmpty ? users.first : null;
  }

  // CRUD para a tabela de medicamento

  Future<int> insertMedicine(Map<String, dynamic> medicine, String dose,
      {required String name}) async {
    Database db = await database;
    return await db.insert(medicineTable, medicine);
  }

  Future<List<Map<String, dynamic>>> getMedicines() async {
    Database db = await database;
    return await db.query(medicineTable);
  }

  Future<int> updateMedicine(Map<String, dynamic> medicine) async {
    Database db = await database;
    return await db.update(medicineTable, medicine,
        where: '$medicineIdCol = ?', whereArgs: [medicine[medicineIdCol]]);
  }

  Future<int> deleteMedicine(int medicineId) async {
    Database db = await database;
    return await db.delete(medicineTable,
        where: '$medicineIdCol = ?', whereArgs: [medicineId]);
  }

  Future<List<Map<String, dynamic>>> getAllMedicines() async {
    Database db = await database;
    return await db.query(medicineTable);
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }

  // Singleton pattern
  DatabaseHelper._privateConstructor();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._privateConstructor();
    return _instance!;
  }
}
