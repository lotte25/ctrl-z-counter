import 'package:flutter/material.dart';
import 'dart:isolate';

import '../models/app_database.dart';
import '../services/keyboard.dart';
import '../providers/database.dart';
import '../providers/discord.dart';

class SessionCounts {
  final int undoCount;
  final int todayCount;

  SessionCounts({required this.undoCount, required this.todayCount});
}

class KeyboardProvider extends ChangeNotifier {
  final AppDatabase db = DatabaseProvider.instance.db;
  final RPCProvider rpcProvider;

  String _currentSession = "default";
  String get currentSession => _currentSession;

  SessionCounts _counts = SessionCounts(undoCount: 0, todayCount: 0);
  SessionCounts get counts => _counts;

  bool _isSessionFinished = false;

  Isolate? _keyboardIsolate;

  KeyboardProvider(this.rpcProvider) {
    _startKeyboardListener();
    updateCounts();
  }

  @override
  void dispose() { 
    _keyboardIsolate?.kill(priority: 0);
    KeyboardHook.stopKeyboardListener();
    super.dispose();
  }

  Future updateCounts() async {
    final newUndoCount = await db.countSessionClicks(sessionName: _currentSession);
    final newTodayCount = await db.countClicksForDate(sessionName: _currentSession);

    _counts = SessionCounts(
      undoCount: newUndoCount, 
      todayCount: newTodayCount
    );
  }

  void setSession(String session, {bool? isFinished}) async {
    _currentSession = session;
    if (isFinished != null) {
      _isSessionFinished = isFinished;
    }

    await updateCounts();
    notifyListeners();
  }

  void setCurrentSessionAsFinished() {
    _isSessionFinished = true;
  }

  void onUndo() async {
    if (_isSessionFinished) {
      return;
    }

    await db.insertUndo(DateTime.now(), _currentSession);
    await updateCounts();
    notifyListeners();

    rpcProvider.updateActivity(_counts.undoCount, _counts.todayCount, _currentSession);
  }

  // Initializes the keyboard hook on another thread and listens to messages sent by it
  void _startKeyboardListener() async {
    final mainReceivePort = ReceivePort();

    mainReceivePort.listen((message) async {
      if (message == "undo") {
        onUndo();
      }
    });

    _keyboardIsolate = await KeyboardHook.startKeyboardListener(mainReceivePort.sendPort);
  }
}