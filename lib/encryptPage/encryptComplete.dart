import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/home.dart';

class EncryptComplete extends StatefulWidget {
  static const routeName = '/encryptComplete';
  @override
  _EncryptCompleteState createState() => _EncryptCompleteState();
}

class _EncryptCompleteState extends State<EncryptComplete> {
  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
              child: FutureBuilder(
          future: videoProvider.deleteVideoFiles(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? Center(
                      child: Container(
                        height: 100,
                        child: Column(
                          children: [
                            Text('Ecryption Complete.'),
                            MaterialButton(
                              child: Text('Proceed to play video'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text('Please Wait'),
                    ),
        ),
      ),
    );
  }
}
