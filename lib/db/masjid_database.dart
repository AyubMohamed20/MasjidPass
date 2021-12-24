import 'package:masjid_pass/models/event.dart';
import 'package:masjid_pass/models/user.dart';
import 'package:masjid_pass/models/visitor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MasjidDatabase {
  static final MasjidDatabase instance = MasjidDatabase._init();
  static Database? _database;

  MasjidDatabase._init();

  ///Creates a DB if there isn't one. Else returns current DB.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('masjidTestingData1.db');
    return _database!;
  }

  ///initializes and opens the db
  Future<Database> _initDB(String filePath) async {
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
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    ///create DB tables
    await db.execute('''
    CREATE TABLE $tableUsers (
    ${UserFields.id} $idType ,
    ${UserFields.username} $textType,
    ${UserFields.password} $textType,
    ${UserFields.organizationId} $integerType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableEvents (
    ${EventFields.id} $idType ,
    ${EventFields.organizationId} $integerType ,
    ${EventFields.eventDateTime} $textType ,
    ${EventFields.hall} $textType ,
    ${EventFields.capacity} $integerType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableVisitors (
    ${VisitorFields.id} $idType ,
    ${VisitorFields.eventId} $integerType ,
    ${VisitorFields.visitorId} $integerType ,
    ${VisitorFields.organization} $textType ,
    ${VisitorFields.door} $textType ,
    ${VisitorFields.direction} $textType ,
    ${VisitorFields.scannerVersion} $textType ,
    ${VisitorFields.deviceId} $textType ,
    ${VisitorFields.deviceLocation} $textType ,
    ${VisitorFields.bookingOverride} $boolType ,
    ${VisitorFields.capacityOverride} $boolType
    )
    ''');
  }

  ///The function that closes the db
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //USER CRUD FUNCTIONS

  /// Creates a user and the ID is auto generated
  Future<User> create(User user) async {
    final db = await instance.database;
    final id = await db.insert(tableUsers, user.toJson());
    return user.copy(id: id);
  }

  ///Selects all users from the table
  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final orderBy = '${UserFields.id} ASC';
    final result = await db.query(tableUsers, orderBy: orderBy);
    return result.map((json) => User.fromJson(json)).toList();
  }

  ///Updates a user
  Future<int> update(User user) async {
    final db = await instance.database;
    return db.update(
      tableUsers,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  ///Deletes a specified user.
  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      tableUsers,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  ///Deletes the User table.
  Future deleteAll() async {
    final db = await instance.database;
    return db.delete(tableUsers);
  }

  //EVENT CRUD

  /// Creates a event and the ID is auto generated
  Future<Event> createEvent(Event event) async {
    final db = await MasjidDatabase.instance.database;
    final id = await db.insert(tableEvents, event.toJson());
    return event.copy(id: id);
  }

  ///Updates a event
  Future<int> updateEvent(Event event) async {
    final db = await MasjidDatabase.instance.database;
    return db.update(
      tableEvents,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> readAllEvents() async {
    final db = await MasjidDatabase.instance.database;
    final orderBy = '${EventFields.id} ASC';
    final result = await db.query(tableEvents, orderBy: orderBy);
    return result.map((json) => Event.fromJson(json)).toList();
  }

  ///Deletes the Event table.
  Future deleteAllEvents() async {
    final db = await MasjidDatabase.instance.database;
    return db.delete(tableEvents);
  }

  Future<int> deleteEvent(int id) async {
    final db = await MasjidDatabase.instance.database;
    return db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  //VISITOR CRUD

  /// Creates a visitor and the ID is auto generated
  Future<Visitor> createVisitor(Visitor visitor) async {
    final db = await MasjidDatabase.instance.database;
    final id = await db.insert(tableVisitors, visitor.toJson());
    return visitor.copy(id: id);
  }

  ///Selects all events from the table
  Future<List<Visitor>> readAllVisitors() async {
    final db = await MasjidDatabase.instance.database;
    final orderBy = '${VisitorFields.id} ASC';
    final result = await db.query(tableVisitors, orderBy: orderBy);
    return result.map((json) => Visitor.fromJson(json)).toList();
  }

  ///Updates a event
  Future<int> updateVisitor(Visitor visitor) async {
    final db = await MasjidDatabase.instance.database;
    return db.update(
      tableVisitors,
      visitor.toJson(),
      where: '${VisitorFields.id} = ?',
      whereArgs: [visitor.id],
    );
  }

  ///Deletes a specified event.
  Future<int> deleteVisitor(int id) async {
    final db = await MasjidDatabase.instance.database;
    return db.delete(
      tableVisitors,
      where: '${VisitorFields.id} = ?',
      whereArgs: [id],
    );
  }

  ///Deletes the Event table.
  Future deleteAllVisitors() async {
    final db = await MasjidDatabase.instance.database;
    return db.delete(tableEvents);
  }
}
