import 'package:just_audio/just_audio.dart';


Future<void> playSound(String assetName) async {
  final player = AudioPlayer(handleAudioSessionActivation: false);

  await player.setAsset("assets/sounds/$assetName.mp3");
  
  player.playerStateStream.listen((playerState) async {
    if (playerState.processingState == ProcessingState.completed)  {
      await player.stop();
    }
  });

  await player.play();
}