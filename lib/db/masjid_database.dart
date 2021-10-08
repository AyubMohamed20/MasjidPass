import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:masjid_pass/models/user.dart';

class MasjidDatabase{
  static final MasjidDatabase instance = MasjidDatabase._init();

  static Database? _database;
  MasjidDatabase._init();

  ///Creates a DB if there isn't one. Else returns current DB.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('masjid.db');
    return _database!;

  }

  ///initializes and opens the db
  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print(dbPath);
    ///opens the database ,checks the path, version, and schema.
    ///can add onUpgrade param if schema changes in future.
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  ///Function that creates the db tables and forms the schema.
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    ///create DB tables
    await db.execute('''
    CREATE TABLE $tableUsers (
    ${UserFields.id} $idType ,
    ${UserFields.username} $textType,
    ${UserFields.password} $textType
    )
    ''');

  }

  ///The function that closes the db
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //CRUD FUNCTIONS

  /// Creates a user and the ID is auto generated
  Future<User> create(User user) async{
    final db = await instance.database;
    final id = await db.insert(tableUsers, user.toJson());
    return user.copy(id: id);
  }

  ///Selects all users from the table
  Future<List<User>> readAllUsers()async{
    final db = await instance.database;
    final orderBy = '${UserFields.id} ASC';
    final result = await db.query(tableUsers, orderBy: orderBy);
    return result.map((json)=>User.fromJson(json)).toList();
  }
  ///Updates a user
  Future<int> update (User user) async {
    final db = await instance.database;
    return db.update(
        tableUsers,
        user.toJson(),
        where: '${UserFields.id} = ?',
        whereArgs: [user.id],
    );
  }
  ///Deletes a specified user.
  Future<int> delete(int id) async{
    final db = await instance.database;
    return db.delete(
      tableUsers,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }
  ///Deletes the User table.
  Future deleteAll() async{
    final db = await instance.database;
    return db.delete(tableUsers);

  }


}