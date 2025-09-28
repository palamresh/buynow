import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VideoDownloadScreen extends StatefulWidget {
  const VideoDownloadScreen({super.key});

  @override
  State<VideoDownloadScreen> createState() => _VideoDownloadScreenState();
}

class _VideoDownloadScreenState extends State<VideoDownloadScreen> {
  var downloadProgress = 0.0;
  late DownloadTask task;

  downloadFile() async {
    final path = await getApplicationDocumentsDirectory();
    task = DownloadTask(
      url:
          "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-MP4-Video-File-Download.mp4",
      filename: "sample-video.mp4",
      directory: path.path,
      updates: Updates.statusAndProgress,
      // requiresWiFi: true,
      retries: 5,
      allowPause: true,
      metaData: "data for me",
    );
    await FileDownloader().download(
      task,
      onProgress: (progress) {
        if (!progress.isNegative) {
          setState(() {
            downloadProgress = progress;
          });
        }
      },
      onStatus: (status) {
        print("status = $status");
      },
    );
  }

  pauseDownload() async {
    await FileDownloader().pause(task);
  }

  resumeDownload() async {
    await FileDownloader().resume(task);
  }

  cancelDownload() async {
    await FileDownloader().cancelTaskWithId(task.taskId).whenComplete(() {
      setState(() {
        downloadProgress = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await downloadFile();
        },
        label: Text("Download"),
      ),
      appBar: AppBar(title: Text("Video Download")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 130,
              lineWidth: 15.0,
              animation: true,
              animationDuration: 100,
              percent: downloadProgress.toDouble(),
              animateFromLastPercent: true,
              progressColor: Colors.blue,
              center: Text(
                "${(downloadProgress * 100).toStringAsFixed(2)}%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    await resumeDownload();
                    setState(() {});
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () async {
                    await pauseDownload();
                    setState(() {});
                  },
                  icon: Icon(Icons.pause),
                ),

                IconButton(
                  onPressed: () async {
                    await cancelDownload();
                    setState(() {});
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
