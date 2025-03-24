import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';

class RichPresence {
  RichPresence._privateConstructor();
  static final RichPresence _instance = RichPresence._privateConstructor();
  static RichPresence get instance => _instance;

  late DateTime timeSinceStart;

  Future<void> initialize() async {
    try {
      await FlutterDiscordRPC.initialize("1251964533027897455");
      connect();
    } catch (e) {
      print("Failed to initialize RPC: $e");
    }
  }

  void connect() {
    try {
      FlutterDiscordRPC.instance.connect(
        autoRetry: true,
        retryDelay: const Duration(seconds: 10),
      );
      timeSinceStart = DateTime.now();
      
      FlutterDiscordRPC.instance.setActivity(
        activity: RPCActivity(
          state: "Waiting for Ctrl + Z's!",
          activityType: ActivityType.watching
        )
      ); 
    } catch (e) {
      print(e); 
    }
  }

  void disconnect() {
    FlutterDiscordRPC.instance.clearActivity();
    FlutterDiscordRPC.instance.disconnect();
  }

  void updateActivity(int totalCount, int todayCount, String session) {
    if (!FlutterDiscordRPC.instance.isConnected) return;
    
    try {
      FlutterDiscordRPC.instance.setActivity(
        activity: RPCActivity(
          state: "Total: $totalCount / Today: $todayCount",
          details: "Counting Ctrl + Z's on $session!",
          timestamps: RPCTimestamps(start: timeSinceStart.millisecondsSinceEpoch),
          activityType: ActivityType.listening,
        ),
      );
    } catch (e) {
      print(e); 
    }
  }
}
