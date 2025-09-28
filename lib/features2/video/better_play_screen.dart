import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class BetterPlayerPlusExample extends StatefulWidget {
  const BetterPlayerPlusExample({super.key});

  @override
  State<BetterPlayerPlusExample> createState() =>
      _BetterPlayerPlusExampleState();
}

class _BetterPlayerPlusExampleState extends State<BetterPlayerPlusExample> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();

    // ✅ Correct DataSource class name
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
      subtitles: [
        BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [
            "https://bitdash-a.akamaihd.net/content/sintel/subtitles/subtitles_en.vtt",
          ],
        ),
      ],
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 100 * 1024 * 1024, // 100 MB
        maxCacheFileSize: 20 * 1024 * 1024, // 20 MB per file
      ),
    );

    // ✅ Correct Controller class name
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enablePlaybackSpeed: true,
          enableSubtitles: true,
          enableQualities: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Better Player Plus Example")),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          // ✅ Widget name is still BetterPlayer
          child: BetterPlayer(controller: _betterPlayerController),
        ),
      ),
    );
  }
}
