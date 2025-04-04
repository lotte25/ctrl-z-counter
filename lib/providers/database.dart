import 'package:ctrlz_counter/models/app_database.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider _instance = DatabaseProvider._privateConstructor();
  static DatabaseProvider get instance => _instance;

  AppDatabase? _database;

  Future<void> initialize() async {
      _database ??= AppDatabase();
  }

  AppDatabase get db {
    if (_database == null) {
      throw Exception("Database not initialized.");
    }

    return _database!;
  }
}