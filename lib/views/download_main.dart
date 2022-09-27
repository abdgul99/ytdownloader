// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow/components/global_button.dart';
import 'package:stackoverflow/controler/provider.dart';
import 'package:stackoverflow/views/downloaded_file.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      ref.read(ytProvider.notifier).getTabBarIndex(tabController.index);
    });
    ref.read(ytProvider.notifier).getDirectory();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dWatch = ref.watch(ytProvider);
    final dRead = ref.read(ytProvider.notifier);
    String thumbnails = dWatch.vThumbnails;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
                child: GlobalButton(
                    label: Text('Download'),
                    onTap: () {
                      dRead.getDownload();
                    })),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DownloadedFile()));
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_downward),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    dWatch.fileName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    height: 200,
                    width: 200,
                    child: thumbnails.isNotEmpty
                        ? Image.network(
                            'https://img.youtube.com/vi/$thumbnails/0.jpg')
                        : Image.asset(
                            'assets/images/yticon.png',
                            color: Colors.red,
                          ),
                  ),
                  // const Text(
                  //   'Insert the video id or url',
                  // ),
                  SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        label: Text('Insert the video id or url'),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 12),
                  GlobalButton(
                      label: dWatch.loadingIndecator
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : Text('Search'),
                      onTap: () {
                        ref
                            .read(ytProvider.notifier)
                            .getFiles(textController.text);
                      }),
                  SizedBox(height: 24),
                  TabBar(
                      controller: tabController,
                      unselectedLabelColor: Colors.blueAccent,
                      // indicatorWeight: 50,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8)),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_file),
                              Text('Video'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.audio_file),
                              Text('Audio'),
                            ],
                          ),
                        ),
                      ]),
                  Expanded(
                    child: TabBarView(controller: tabController, children: [
                      dWatch.vAudio.isNotEmpty
                          ? ListView.builder(
                              itemCount: dWatch.vVideos.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Radio(
                                      value: index,
                                      groupValue: dWatch.vVideoRadioButton,
                                      onChanged: (value) {
                                        dRead.getVideoIndex(index);
                                      }),
                                  title:
                                      Text(dWatch.vVideos[index].qualityLabel),
                                  subtitle: Text(
                                      dWatch.vVideos[index].size.toString()),
                                );
                              })
                          : Center(child: Text('No Video')),
                      dWatch.vAudio.isNotEmpty
                          ? ListView.builder(
                              itemCount: dWatch.vVideos.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Radio(
                                      value: index,
                                      groupValue: dWatch.vAudioRadioButton,
                                      onChanged: (value) {
                                        dRead.getAudioIndex(index);
                                      }),
                                  title: Text(
                                      '${dWatch.vAudio[index].bitrate.kiloBitsPerSecond.ceil()} Kbit/s'),
                                  subtitle: Text(
                                      dWatch.vAudio[index].size.toString()),
                                );
                              })
                          : Center(child: Text('No Audio')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
