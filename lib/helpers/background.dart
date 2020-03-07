import 'package:flutter/services.dart';
import 'package:music_player/music_player.dart';

class LpPlayQueueInterceptor extends PlayQueueInterceptor {
  @override
  Future<List<MusicMetadata>> fetchMoreMusic(
      BackgroundPlayQueue queue, PlayMode playMode) async {
    try {
      return queue.queue;
    } catch (e) {
      print('background error:$e');
      throw MissingPluginException();
    }
  }
}
