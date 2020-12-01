import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptPage.dart';

class DownloadCounter extends StatefulWidget {
  @override
  _DownloadCounterState createState() => _DownloadCounterState();
}

class _DownloadCounterState extends State<DownloadCounter> {
  var downloadProgress = "0";
  bool downloadComplete = false;
  bool isInit = true;
  int statTime = 0;
  statisticsCallback(Statistics statistics) {
    if (statistics.time < 210304)
      setState(() {
        statTime = statistics.time;
        downloadComplete = false;
        downloadProgress = statistics.time.toString();
      });
    else {
      setState(() {
        statTime = statistics.time;
        downloadComplete = true;
        downloadProgress = "Download Complete";
      });
    }
    print('MY PRINT');
    print(statistics.time);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      VideoProvider.ffConfig.enableStatisticsCallback(statisticsCallback);
      isInit = false;
    }
    return downloadComplete
        ? Center(
            child: Container(
              height: 100,
              width: double.infinity,
              child: Column(
                children: [
                  Text('Press to compress the video.'),
                  MaterialButton(
                      child: Text('Proceed'),
                      onPressed: () {
                        Provider.of<VideoProvider>(context, listen: false)
                            .setVideoFile();
                        Navigator.of(context).pushNamed(EncryptPage.routeName);
                      })
                ],
              ),
            ),
          )
        : Center(
            child: Container(
              height: 100,
              child: Stack(
                children: [
                  Container(
                      height: 24,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  AnimatedContainer(
                      height: 24,
                      width: .0016642575 * statTime,
                      duration: Duration(milliseconds: 10),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  Positioned(
                  bottom: 10,
                  left: 100,
                      //alignment: Alignment.bottomCenter,
                      child: Text('Download In Progress')),
                ],
              ),
            ),
          );
  }
}

//210304
