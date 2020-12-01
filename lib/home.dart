import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/downloadInProgressPage/downloadInProgressPage.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptCounter.dart';

import 'package:videoAssessmentSuprano/videoPage/videoPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<int>(
          future: videoProvider.doesVideoExist(),
          builder: (context, doesExist) {
            if (doesExist.connectionState == ConnectionState.done) {
              print("done");
              if (doesExist.data == 1)
                return Center(
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text('Click to continue to play the video'),
                        MaterialButton(
                            child: Text('Decrypt'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(VideoPage.routeName);
                            })
                      ],
                    ),
                  ),
                );
              else if (doesExist.data == 2) {
                return EncryptCounter(true);
              } else
                return Center(
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text('Video needs to be downloaded. Click to proceed.'),
                        MaterialButton(
                            child: Text('Download'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(DownloadInProgressPage.routeName);
                            })
                      ],
                    ),
                  ),
                );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
