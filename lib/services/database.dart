import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Undo {
  final int? id;
  final String session;
  final DateTime timestamp;

  Undo({
    this.id,
    required this.session,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session': session,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Undo.fromMap(Map<String, dynamic> map) {
    return Undo(
      id: map['id'],
      session: map['session'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class Session {
  final int? id;
  final String name;
  final DateTime createdAt;
  final bool finished;

  Session({
    this.id,
    required this.name,
    required this.createdAt,
    this.finished = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'finished': finished ? 1 : 0,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
      finished: map['finished'] == 1,
    );
  }
}

class AppDatabase {
  AppDatabase.internal();
  static final AppDatabase instance = AppDatabase.internal();
  static Database? _database;
  Database get database => _database!;

  Future<void> initialize() async {
    if (_database != null) return;

    final documentsDirectory = await getApplicationDocumentsDirectory();

    final dataDirectory = Directory(path.join(documentsDirectory.path, "Ctrl+Z Counter"));

    if (!await dataDirectory.exists()) {
      await dataDirectory.create(recursive: true);
    }

    final dbpath = path.join(dataDirectory.path, "data.db");

    _database = await openDatabase(
      dbpath,
      version: 1,
      onCreate: _createDb,
      onOpen: (db) async {
        await db.execute("PRAGMA journal_mode=WAL");
        await db.execute("PRAGMA synchronous=NORMAL");
      }
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE undoes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      session TEXT NOT NULL CHECK(length(session) >= 3 AND length(session) <= 32),
      timestamp TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE sessions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL CHECK(length(name) >= 3 AND length(name) <= 32),
      created_at TEXT NOT NULL,
      finished INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  // CRUD functions i think they were called?
  Future<void> createUndo(DateTime timestamp, String session) async {
    await database.insert("undoes", Undo(session: session, timestamp: timestamp).toMap());
  }

  Future<int> countClicks({String sessionName = "default"}) async {
    final undoes = await database.query(
      "undoes",
      where: "session = ?",
      whereArgs: [sessionName]
    );

    return undoes.length;
  }

  Future<int> countDateClicks({String sessionName = "default", String? today, String? tomorrow}) async {
    final result = await database.query(
      "undoes",
      columns: ["COUNT(*) as count"],
      where: "timestamp >= ? AND timestamp < ? AND session = ?",
      whereArgs: [today, tomorrow, sessionName]
    );

    return result.first["count"] as int;
  }

  Future<List<Map<String, Object?>>> retrieveSessions() async {
    final result = await database.query("sessions");

    return result;
  }

  Future<bool> sessionExists(String sessionName) async {
    final result = await database.query(
      "sessions",
      where: "name = ?",
      whereArgs: [sessionName]
    );

    return result.isNotEmpty;
  }

  Future<bool> createSession(DateTime createdAt, String sessionName) async {
    final map = Session(name: sessionName, createdAt: createdAt, finished: false).toMap();

    final result = await database.insert(
      "sessions", 
      map
    );

    return result == 1;
  }
  
  Future<void> deleteSession(String sessionName) async {
    await database.transaction((txn) async {
      // Delete session from table
      await txn.delete(
        "sessions", 
        where: "name = ?",
        whereArgs: [sessionName] 
      );

      // Delete all clicks related to that session
      await txn.delete(
        "undoes",
        where: "session = ?",
        whereArgs: [sessionName]
      );
    });
  }

  Future<void> finishSession(String sessionName) async {
    await database.update(
      "sessions",
      { "finished": 1 },
      where: "name = ?",
      whereArgs: [sessionName]
    );
  }

  void close() {
    _database?.close();
  }
}