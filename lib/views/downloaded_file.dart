import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow/controler/provider.dart';
import 'package:stackoverflow/main.dart';

class DownloadedFile extends StatelessWidget {
  const DownloadedFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final fWatch = ref.watch(ytProvider);
        final fRead = ref.read(ytProvider.notifier);
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: fWatch.vDownloadedFiles.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      leading: Icon(fWatch.extensionFilter[index] == '.mp3'
                          ? Icons.audio_file
                          : Icons.video_file),
                      title: Text(fWatch.vDownloadedFiles[index]),
                      trailing: IconButton(
                          onPressed: () {
                            fRead.deleteFile(index);
                          },
                          icon: Icon(Icons.delete)),
                    );
                  })),
            )
          ],
        );
      }),
    ));
  }
}
