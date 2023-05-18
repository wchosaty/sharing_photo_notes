import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/utils/http_connection.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';
import 'package:sharing_photo_notes/widgets/page_view_global.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  static const tag = 'tag _BrowsePageState';
  late List<AlbumList> albumLists;
  late String localUsername;
  late int oldestAlbumId;
  late int latestAlbumId;

  @override
  void initState() {
    super.initState();
    albumLists = [];
    localUsername = '';
    int oldestAlbumId = 0;
    int latestAlbumId = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (MyApp.localUser.isNotEmpty && MyApp.localUser != localUsername) {
      LogData().d(tag, "_BrowsePageState.localUser.isNotEmpty");
      initialData();
    }

    return Scaffold(
        backgroundColor: colorBackground,
        // bottomNavigationBar: const MainBottomNavigationBar(),
        body: Container(
          margin: const EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: albumLists.length,
              itemBuilder: (context, i) {
              return PageViewGlobal(albumList: albumLists[i]);
                }
              )
        )
    );
  }

  Future initialData() async{
    localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);
    Map<String, String> headerCloudAlbum = {sAction: sQuery, sContent: sAlbum, sType: sStatus};
    Map<String, int> map = {sContent: statusPublic};
    String jsonCloudAlbum = jsonEncode(map);
    LogData().dd(tag, 'jsonCloudAlbum', jsonCloudAlbum);
    var backCloudAlbumList =
    await HttpConnection().toServer(ip: urlIp, path: urlServerAlbumPath,json: jsonCloudAlbum, headerMap: headerCloudAlbum);

    LogData().dd(tag, "backCloudAlbum", backCloudAlbumList.toString());
    List<AlbumList> list = [];
    if (backCloudAlbumList.isNotEmpty) {
      LogData().d(tag, "backCloudAlbum.isNotEmpty");
      for(int i=0;i<backCloudAlbumList.length;i++) {
        list.add(AlbumList.fomJson(backCloudAlbumList[i] as Map<String, dynamic>));
      }
      setState(() {
        albumLists.addAll(list);
      });

    }else LogData().d(tag, "backCloudAlbum.isEmpty");
  }
}
