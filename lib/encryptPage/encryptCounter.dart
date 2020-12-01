import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptComplete.dart';

class EncryptCounter extends StatefulWidget {
  EncryptCounter([this.compressComplete = false]);
  final bool compressComplete;
  @override
  _EncryptCounterState createState() => _EncryptCounterState();
}

class _EncryptCounterState extends State<EncryptCounter> {
  bool isInit = true;
  bool compressComplete = false;
  var compressProgress = "0";
  int statTime = 0;
  statisticsCallback(Statistics statistics) {
    if (statistics.time < 210218)
      setState(() {
        statTime = statistics.time;
        compressComplete = false;
        compressProgress = statistics.time.toString();
      });
    else {
      setState(() {
        statTime = statistics.time;
        compressComplete = true;
        compressProgress = "Compress Complete";
      });
    }
    print('MY PRINT');
    print(statistics.time);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compressComplete) compressComplete = widget.compressComplete;
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final encryptComplete =
        Provider.of<VideoProvider>(context, listen: true).encryptComplete;
    if (isInit) {
      VideoProvider.ffConfig.enableStatisticsCallback(statisticsCallback);
      isInit = false;
    }
    return compressComplete
        ? FutureBuilder(
            future: videoProvider.copyTempToExt(),
            builder: (context, encrypting) {
              if (encrypting.connectionState == ConnectionState.done) {
                print(encryptComplete);
                if (encryptComplete)
                  return Center(
                    child: Column(
                      children: [
                        Text('Click to Delete Files'),
                        MaterialButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EncryptComplete.routeName);
                          },
                        )
                      ],
                    ),
                  );
              }

              return Center(
                child: Column(
                  children: [
                    Text('Ecrypting Video... Please Wait.'),
                    SizedBox(
                      height: 24,
                    ),
                    Text('This might take a few minutes')
                  ],
                ),
              );
            },
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
                    width: .0016649383 * statTime,
                    duration: Duration(milliseconds: 10),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 100,
                      //alignment: Alignment.bottomCenter,
                      child: Text('Compressing Video')),
                ],
              ),
            ),
          );
  }
}
