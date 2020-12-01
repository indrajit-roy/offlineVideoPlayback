import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/downloadInProgressPage/downloadCounter.dart';

class DownloadInProgressPage extends StatefulWidget {
  static const routeName = '/downloadInProgressPage';
  @override
  _DownloadInProgressPageState createState() => _DownloadInProgressPageState();
}

class _DownloadInProgressPageState extends State<DownloadInProgressPage> {
  bool isDownloading = false;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: isDownloading
                ? downloadingPage(context)
                : pressToDownload(context)));
  }

  Widget pressToDownload(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: double.infinity,
        child: Column(
          children: [
            Text('Press download to watch the video.'),
            MaterialButton(
                child: Text('Download'),
                onPressed: () {
                  if (!isDownloading)
                    setState(() {
                      isDownloading = true;
                    });
                })
          ],
        ),
      ),
    );
  }

  Widget downloadingPage(BuildContext context) {
    
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) => FutureBuilder(
        future: videoProvider.convertM3u8ToMp4(),
        builder: (context, downloading) {
          if (downloading.connectionState == ConnectionState.done)
            return DownloadCounter();
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24,),
                Text('Downloading Video')
              ],
            ),
          );
        },
      ),
    );
  }
}

// if (videoProvider.videoFile != null) {
//             
//           }
