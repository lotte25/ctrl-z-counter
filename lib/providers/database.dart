import 'package:drift/drift.dart';
import 'package:ctrlz_counter/models/app_database.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider _instance = DatabaseProvider._privateConstructor();
  static DatabaseProvider get instance => _instance;

  AppDatabase? _db;

  Future<void> initialize() async {
      _db ??= AppDatabase();
  }

  AppDatabase get db {
    if (_db == null) {
      throw Exception("Database not initialized.");
    }

    return _db!;
  }

  Future<void> insertUndo(DateTime timestamp, String session) async {
    await db.into(db.undoes).insert(UndoesCompanion.insert(
      session: session,
      timestamp: timestamp
    ));
  }

  Future<int> countSessionClicks({String sessionName = "default"}) async {
    final query = db.select(db.undoes)
      ..where((row) => row.session.equals(sessionName));

    final results = await query.get();
    return results.length;
  }

  Future<int> countClicksForDate({String sessionName = "default", DateTime? date}) async {
    DateTime now = date ?? DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));

    final query = db.select(db.undoes);

    final count = await (query
      ..where((row) => row.timestamp.isBiggerOrEqualValue(today))
      ..where((row) => row.timestamp.isSmallerThanValue(tomorrow))
      ..where((row) => row.session.equals(sessionName))
    ).get();
    
    return count.length;
  }

  Future<int> countUndoes() async {
    return await db.undoes.count().getSingle();
  }

  Future<List<Session>> getSessions() async => await db.select(db.sessions).get();

  Future<bool> sessionExists(String sessionName) async {
    int count = await db.sessions.count(where: (s) => s.name.equals(sessionName)).getSingle();
    
    return (count > 0);
  }

  Future<void> createSession(DateTime createdAt, String sessionName) async {
    await db.into(db.sessions).insert(SessionsCompanion.insert(
      name: sessionName, 
      createdAt: createdAt,
      finished: Value(false)
    ));
  }

  Future<void> deleteSession(String sessionName) async {
    await db.transaction(() async {
      await (db.delete(db.undoes)..where((row) => row.session.equals(sessionName))).go();
      await (db.delete(db.sessions)..where((row) => row.name.equals(sessionName))).go();
    });
  }

  Future<void> finishSession(String sessionName) async {
    await (db.update(db.sessions)..where((s) => s.name.equals(sessionName)))
        .write(SessionsCompanion(finished: Value(true)));
  }
}