import 'package:ctrlz_counter/services/discord_rpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';

class RPCProvider extends ChangeNotifier {
  final RichPresence _richPresence = RichPresence.instance;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    await _richPresence.initialize();
    
    FlutterDiscordRPC.instance.isConnectedStream.listen((connected) {
      _isConnected = connected;
      notifyListeners();
    });
  }

  void updateActivity(int totalCount, int todayCount, String session) {
    _richPresence.updateActivity(totalCount, todayCount, session);
  }
}