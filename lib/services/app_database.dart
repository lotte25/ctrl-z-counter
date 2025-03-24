import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Undoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get session => text().withLength(min: 3, max: 32)();
  DateTimeColumn get timestamp => dateTime()();
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 32)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get finished => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Undoes, Sessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: "ctrlz_counter",
    );
  }

  Future<void> insertUndo(DateTime timestamp, String session) async {
    await into(undoes).insert(UndoesCompanion.insert(
      session: session,
      timestamp: timestamp
    ));
  }

  Future<int> countSessionClicks({String sessionName = "default", bool today = false}) async {
    return await undoes.count(
      where: (row) => row.session.equals(sessionName)
    ).getSingle();
  }

  Future<int> countClicksForDate({String sessionName = "default", DateTime? date}) async {
    DateTime now = date ?? DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));

    final count = await (select(undoes)
      ..where((row) => row.timestamp.isBiggerOrEqualValue(today))
      ..where((row) => row.timestamp.isSmallerThanValue(tomorrow))
      ..where((row) => row.session.equals(sessionName))
    ).get();
    
    return count.length;
  }

  Future<int> countUndoes() async {
    return await undoes.count().getSingle();
  }

  Future<List<Session>> getSessions() async => await select(sessions).get();

  Future<bool> sessionExists(String sessionName) async {
    int count = await sessions.count(where: (s) => s.name.equals(sessionName)).getSingle();
    
    return (count > 0);
  }
  
  Future<void> createSession(DateTime createdAt, String sessionName) async {
    await into(sessions).insert(SessionsCompanion.insert(
      name: sessionName, 
      createdAt: createdAt,
      finished: Value(false)
    ));
  }

  Future<void> deleteSession(String sessionName) async {
    await transaction(() async {
      await (delete(undoes)..where((row) => row.session.equals(sessionName))).go();
      await (delete(sessions)..where((row) => row.name.equals(sessionName))).go();
    });
  }

  Future<void> finishSession(String sessionName) async {
    await (update(sessions)..where((s) => s.name.equals(sessionName)))
        .write(SessionsCompanion(finished: Value(true)));
  }
  
}