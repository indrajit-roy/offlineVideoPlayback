import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/videoPage/components/videoItem.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key, this.title}) : super(key: key);

  final String title;
  static const routeName = '/videopage';
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return Scaffold(
      body: FutureBuilder<File>(
        future: videoProvider.getVideoFromLocal(),

        //_videoPlayerController.initialize(),
        builder: (context, decryptedFile) {
          if (decryptedFile.connectionState == ConnectionState.done) {
            _videoPlayerController =
                VideoPlayerController.file(decryptedFile.data);

            return FutureBuilder<void>(
              future: _videoPlayerController.initialize(),
              builder: (context, init) {
                if (init.connectionState == ConnectionState.done)
                  return ListView(
                    children: [
                      VideoItem(
                        videoPlayerController: _videoPlayerController,
                        looping: false,
                      ),
                    ],
                  );
                return Center(
                  child: Container(
                    height: 100,
                    child: Text('Getting Things ready...'),
                  ),
                );
              },
            );
          }
          return Center(
            child: Container(
              height: 100,
              child: Column(
                children: [
                  Text(
                      'Decrypting your Video File ... This might take some time.'),
                  SizedBox(
                    height: 24,
                  ),
                  Text('Dont worry. The app hasnt hanged.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// storage/emulated/0/Android/data/com.example.videoAssessmentSuprano/files/f08e80da-bf1d-4e3d-8899-f0f6155f6efa_video_180_250000.m3u8
// storage/emulated/0/Android/data/com.example.videoAssessmentSuprano/files
