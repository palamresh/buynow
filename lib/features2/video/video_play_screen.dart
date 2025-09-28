import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  const VideoPlayScreen({super.key});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  @override
  void initState() {
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(
          // "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: Center(
        child:
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : CircularProgressIndicator(),
      ),
    );
  }
}
