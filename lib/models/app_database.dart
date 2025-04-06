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
}