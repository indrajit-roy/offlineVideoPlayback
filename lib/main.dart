import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/downloadInProgressPage/downloadInProgressPage.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptComplete.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptPage.dart';
import 'package:videoAssessmentSuprano/home.dart';
import 'package:videoAssessmentSuprano/videoPage/videoPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: VideoProvider(),
          )
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Suprano Demo',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: FutureBuilder(
                future: Provider.of<VideoProvider>(context, listen: false)
                    .initiateDirectories(),
                builder: (context, snapshot) => Home()),
            routes: {
              VideoPage.routeName: (ctx) => VideoPage(),
              DownloadInProgressPage.routeName: (ctx) =>
                  DownloadInProgressPage(),
              EncryptPage.routeName: (ctx) => EncryptPage(),
              EncryptComplete.routeName: (ctx) => EncryptComplete(),
            },
          );
        });
  }
}
