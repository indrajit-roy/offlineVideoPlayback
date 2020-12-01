import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


class VideoItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const VideoItem(
      {Key key, @required this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  ChewieController _chewieController;
  File _file;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        print('ERROR => $errorMessage');
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.amber),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return _chewieController != null
        // &&
        //         _chewieController.videoPlayerController.value.initialized
        ? Center(
            child: Container(
              color: Colors.amber,
              height: (MediaQuery.of(context).size.width / 16) * 9,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
