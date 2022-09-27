import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeMainClass extends ChangeNotifier {
  List<Future<void>> downloadMethods = [];
  List<String> vDownloadedFiles = [];
  List<String> emptyList = [];
  List<String> extensionFilter = [];
  String vThumbnails = '';
  String fileName = '';
  bool loadingIndecator = false;
  List<MuxedStreamInfo> vVideos = [];
  List<AudioOnlyStreamInfo> vAudio = [];
  int? vVideoRadioButton;
  int? vAudioRadioButton;
  int vTabBarIndex = 0;
  String VvideoId = '';

  Future<void> getDirectory() async {
    final myDir = Directory('storage/emulated/0/Download/ytDownload/');

    //this will create a directory
    if (myDir.existsSync()) {
    } else {
      myDir.create();
    }

    vDownloadedFiles.clear();
    extensionFilter.clear();
    List<FileSystemEntity> listFiles = myDir.listSync().map((e) => e).toList();

    for (var file in listFiles) {
      String extension =
          file.toString().substring(file.toString().length - 10).toLowerCase();

      if (extension.contains(RegExp(r'(.mp3|.mp4|.3gp)'))) {
        if (extension.contains('.mp3')) {
          extensionFilter.add('.mp3');
        } else {
          extensionFilter.add('.mp4');
        }
        vDownloadedFiles.add(file
            .toString()
            .replaceAll(myDir.path, '')
            .replaceAll('File:', '')
            .replaceAll('Directory:', '')
            .replaceAll('\'', '')
            .trimLeft());
      }
    }
    notifyListeners();
  }

  Future<void> deleteFile(int index) async {
    final myDir = Directory('storage/emulated/0/Download/ytDownload/');
    await myDir.listSync().elementAt(index).delete();
    vDownloadedFiles.removeAt(index);
    notifyListeners();
  }

  Future<void> getFiles(String videoId) async {
    loadingIndecator = true;
    VvideoId = videoId;
    notifyListeners();
    var yt = YoutubeExplode();
    var videoInfo = await yt.videos.get(videoId);
    vThumbnails = videoInfo.thumbnails.videoId;
    fileName = videoInfo.title;
    notifyListeners();
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var videos = manifest.muxed;
    var audios = manifest.audioOnly;
    vVideos = videos;
    vAudio = audios;
    loadingIndecator = false;

    notifyListeners();
  }

  void getVideoIndex(int index) {
    vVideoRadioButton = index;
    vAudioRadioButton = null;
    notifyListeners();
  }

  void getAudioIndex(int index) {
    vAudioRadioButton = index;
    vVideoRadioButton = null;
    notifyListeners();
  }

  void getTabBarIndex(int index) {
    vTabBarIndex = index;
    vAudioRadioButton = null;
    vVideoRadioButton = null;

    notifyListeners();
  }

  Future<void> getDownload() async {
    downloadMethods.add(download());
  }

  Future<void> download() async {
    var yt = YoutubeExplode();

    var name = fileName
        .toString()
        .replaceAll(' ', '_')
        .replaceAll('\'', '')
        .replaceAll('"', '')
        .replaceAll('\$', '')
        .replaceAll('|', '');
    //Video downloader
    if (vVideoRadioButton != null) {
      //${vVideos.elementAt(vVideoRadioButton!).container.name}
      final file = File('storage/emulated/0/Download/ytDownload/$name.mp4');
      if (file.existsSync()) {
        file.delete();
      }
      var saveFile = file.openWrite(mode: FileMode.writeOnlyAppend);
      var downloadVideo =
          yt.videos.streamsClient.get(vVideos.elementAt(vVideoRadioButton!));
      var len = vVideos.elementAt(vVideoRadioButton!).size.totalBytes;
      var count = 0;
      await for (final data in downloadVideo) {
        count += data.length;
        print(((count / len) * 100).ceil());
        saveFile.add(data);
      }
      //audio downloader
      saveFile.close();
    }
    if (vAudioRadioButton != null) {
      final file = File('storage/emulated/0/Download/ytDownload/$name.mp3');
      // file.delete();
      var saveFile = file.openWrite(mode: FileMode.writeOnlyAppend);
      var downloadAudio =
          yt.videos.streamsClient.get(vAudio.elementAt(vAudioRadioButton!));
      var len = vAudio.elementAt(vAudioRadioButton!).size.totalBytes;
      var count = 0;
      await for (final data in downloadAudio) {
        count += data.length;
        print(((count / len) * 100).ceil());
        saveFile.add(data);
      }
      //audio downloader

      saveFile.close();
    }
    getDirectory();
  }
}
// var audioStream = yt.videos.streamsClient.get(video);
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // /storage/emulated/0/Download/
    // final file = File('storage/emulated/0/Download/');

    // var saveFile = file.openWrite(mode: FileMode.writeOnlyAppend);
    // var len = video.size.totalBytes;
    // print(len);
    // var count = 0;
    // await for (final data in audioStream) {
    //   count += data.length;

    //   var progress = ((count / len) * 100).ceil();
    //   print(progress);
    //   print(file);
    //   saveFile.add(data);
    // }

    // ref.writeFromSync(getaudio);
    // Display info about this video.
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(
    //           'Title: ${video.title}, Duration: ${video.duration}'),
    //     );
    //   },
    // );

    // Request permission to write in an external directory.
    // (In this case downloads)
    // await Permission.storage.request();

    // // Get the streams manifest and the audio track.
    // var manifest = await yt.videos.streamsClient.getManifest(id);
    // var audio = manifest.audioOnly.last;

    // // Build the directory.
    // var dir = await DownloadsPathProvider.downloadsDirectory;
    // var filePath = path.join(dir!.uri.toFilePath(),
    //     '${video.id}.${audio.container.name}');

    // Open the file to write.
    // var file = File(filePath);
    // var fileStream = file.openWrite();

    // // Pipe all the content of the stream into our file.
    // await yt.videos.streamsClient.get(audio).pipe(fileStream);
    /*
                  If you want to show a % of download, you should listen
                  to the stream instead of using `pipe` and compare
                  the current downloaded streams to the totalBytes,
                  see an example ii example/video_download.dart
                   */

    // Close the file.
    // await fileStream.flush();
    // await fileStream.close();

    // // Show that the file was downloaded.
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(
    //           'Download completed and saved to: ${filePath}'),
    //     );
    //   },
    // );