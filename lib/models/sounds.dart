

import 'package:audioplayers/audio_cache.dart';
class Sounds{
  static AudioCache _audioPlayer = AudioCache();
  static playSound(String soundURL){
     _audioPlayer.play(soundURL);
  }
}