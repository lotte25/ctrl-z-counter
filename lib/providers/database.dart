import 'package:ctrlz_counter/services/database.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider _instance = DatabaseProvider._privateConstructor();
  static DatabaseProvider get instance => _instance;

  AppDatabase? _db;

  Future<void> initialize() async {
      _db ??= AppDatabase.instance;
  }

  AppDatabase get db {
    if (_db == null) {
      throw Exception("Database not initialized.");
    }

    return _db!;
  }

  Future<void> insertUndo(DateTime timestamp, String session) async {
    await db.createUndo(timestamp, session);
  }

  Future<int> countSessionClicks({String sessionName = "default"}) async {
    return await db.countClicks(sessionName: sessionName);
  }

  Future<int> countClicksForDate({String sessionName = "default", DateTime? date}) async {
    DateTime now = date ?? DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));

    final todayStr = today.toIso8601String();
    final tomorrowStr = tomorrow.toIso8601String();

    final count = await db.countDateClicks(
      sessionName: sessionName,
      today: todayStr,
      tomorrow: tomorrowStr
    );

    return count;
  }

  Future<int> countUndoes() async {
    return await db.countClicks();
  }

  Future<List<Session>> getSessions() async {
    final results = await db.retrieveSessions();

    return results.map((map) => Session.fromMap(map)).toList();

  }

  Future<bool> sessionExists(String sessionName) async => await db.sessionExists(sessionName);

  Future<bool> createSession(DateTime createdAt, String sessionName) async {
    return await db.createSession(createdAt, sessionName);
  }

  Future<void> deleteSession(String sessionName) async {
    await db.deleteSession(sessionName);
  }

  Future<void> finishSession(String sessionName) async {
    await db.finishSession(sessionName);
  }
}