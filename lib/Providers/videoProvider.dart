import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart' as ffmpeg;

import 'package:aes_crypt/aes_crypt.dart';

class VideoProvider with ChangeNotifier {
  static const String _url =
      'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8';

  static const String fileName = 'video.mp4';

  static Directory temporaryDirectory;
  static Directory externalDirectory;
  static ffmpeg.FlutterFFmpeg _ff = ffmpeg.FlutterFFmpeg();
  static ffmpeg.FlutterFFmpegConfig ffConfig = ffmpeg.FlutterFFmpegConfig();
  static AesCrypt _crypt = AesCrypt('password');
  static StreamController<int> _streamController;
  File _videoFile;
  static int _videoTime = 0;
  bool _encryptComplete = false;

  File get videoFile {
    return File('${temporaryDirectory.path}/large$fileName');
  }

  bool get encryptComplete {
    return _encryptComplete;
  }

  Future<void> initiateDirectories() async {
    temporaryDirectory = await path.getApplicationDocumentsDirectory();
    externalDirectory = await path.getExternalStorageDirectory();
    _crypt.setOverwriteMode(AesCryptOwMode.on);
  }

  Future<int> doesVideoExist() async {
    final exists =
        await File('${externalDirectory.path}/$fileName.aes').exists();
    final existsCompressed =
        await File('${externalDirectory.path}/$fileName').exists();
    print(exists);
    print(existsCompressed);
    if (exists)
      return 1;
    else if (existsCompressed) {
      return 2;
    } else
      return 0;
  }

  setVideoFile() {
    _videoFile = File('${temporaryDirectory.path}/large$fileName');
  }

  Future convertM3u8ToMp4() async {
    print(_url);
    print('Downloading..');

    try {
      final convertResult = await _ff.executeAsync(
          '-i $_url -c copy -bsf:a aac_adtstoasc -f mp4 -y ${temporaryDirectory.path}/large$fileName',
          (executionId, returnCode) {
        print('CALL BACK METHOD');
        print(executionId);
        print(returnCode);
      });

      print(convertResult);
    } catch (e) {
      print('DOWNLOADING ERROR => $e');
    }
  }

  Future compress() async {
    final compressResult = await _ff.executeAsync(
        ' -i ${temporaryDirectory.path}/large$fileName -b 2500k -y ${externalDirectory.path}/$fileName',
        (executionId, returnCode) {});
  }

  Future<void> copyTempToExt() async {
    print('Video is here!');

    _videoFile = File('${externalDirectory.path}/$fileName');
    _encryptComplete = false;
    try {
      print('Starting encrypt');
      final byteFile = await _videoFile.readAsBytes();
      _crypt
          .encryptDataToFile(
              byteFile, '${externalDirectory.path}/$fileName.aes')
          .then((value) {
            _encryptComplete = true;
        print('PATHHH => $value');
        
      });
    } catch (e) {
      print('EXCEPTION => $e');
    } finally {}
  }

  Future deleteVideoFiles() async {
    _videoFile = File('${externalDirectory.path}/$fileName');
    if (videoFile.existsSync()) final deleteResponse = await videoFile.delete();
    if (_videoFile.existsSync())
      final deleteResponse = await _videoFile.delete();
    print('Files deleted');
  }

  Future<File> getVideoFromLocal() async {
    final decryptedBytes = await _crypt
        .decryptDataFromFile('${externalDirectory.path}/$fileName.aes');
    final _videoFile = await File('${temporaryDirectory.path}/$fileName}')
        .writeAsBytes(decryptedBytes);
    return _videoFile;
  }

  // downloadVideo() async {
  //   Dio dio = Dio();
  //   final tempDir = await path.getExternalStorageDirectory();

  //   print('TEMP DIR => ${tempDir.path}');

  //   final Response<dynamic> response = await dio.download(
  //     _url,
  //     '${tempDir.path}/$fileName',
  //     onReceiveProgress: (count, total) {
  //       print('COUNT => $count');
  //       print('TOTAL => $total');
  //     },
  //   );
  //   final statusCode = response.statusCode;
  //   final data = response.data;
  //   final message = response.statusMessage;
  //   print('STATUS CODE => $statusCode');
  //   print('DATA => $data');
  //   print('MESSAGE => $message');
  // }
}
