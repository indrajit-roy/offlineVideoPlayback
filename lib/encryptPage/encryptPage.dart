import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:videoAssessmentSuprano/Providers/videoProvider.dart';
import 'package:videoAssessmentSuprano/encryptPage/encryptCounter.dart';

class EncryptPage extends StatefulWidget {
  static const routeName = '/encryptPage';
  @override
  _EncryptPageState createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context,listen: false);
    
    return Scaffold(
      body: FutureBuilder(
          future: videoProvider.compress(),
          builder: (context, snapshot) => Center(child: Container(height: 100,
            child: EncryptCounter()))),
    );
  }
}
