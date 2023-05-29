import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/models/transfer_image.dart';
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
  late double cacheHeight = 0;
  late double screenHeight = 0;
  late List<Uint8List> avatars;
  @override
  void initState() {
    super.initState();
    localUsername = '';
    albumLists = [];
    avatars = [];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.01;
    final height = MediaQuery.of(context).size.height * 0.01;
    if (MyApp.localUser.isNotEmpty && MyApp.localUser != localUsername) {
      LogData().d(tag, "_BrowsePageState.localUser.isNotEmpty");
      initialData();
    }

    return Scaffold(
        backgroundColor: colorBackground,
        body: Container(
            margin: const EdgeInsets.only(top: 3,left: 1,right: 1),
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                cacheExtent: cacheHeight,
                itemCount: albumLists.length,
                itemBuilder: (context, i) {
                  return Container(
                      margin: const EdgeInsets.only(top: 1, bottom: 1),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 1, bottom: 1),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: width * 100,
                                  height: 50,
                                ),
                                Positioned(
                                    top: 2,
                                    left: width,
                                    bottom: 2,
                                    child: avatars[i].isNotEmpty
                                        ? ClipOval(child: Image.memory(avatars[i] ,width: 50,height: 50,fit: BoxFit.cover,))
                                        :Image.asset(
                                      imageAccount,
                                      fit: BoxFit.cover,
                                      color: Colors.black,
                                    )),
                                Positioned(
                                    top: 5,
                                    left: width * 15,
                                    child: Text(albumLists[i].username,
                                        style: const TextStyle(
                                          letterSpacing: 0.5,
                                          color: Colors.black,
                                          fontSize: sFontSizeAlbumUsername,
                                        ))),
                                Positioned(
                                  bottom: 0,
                                  left: width * 40,
                                  child: Text(albumLists[i].album_name,
                                      style: const TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: sFontSizeAlbumName,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          PageViewGlobal(albumList: albumLists[i]),
                        ],
                      ));
                })));
  }

  Future initialData() async {
    localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);
    Map<String, String> headerCloudAlbum = {
      sAction: sQuery,
      sContent: sAlbumList,
      sType: sStatus
    };
    Map<String, int> map = {sContent: statusPublic};
    String jsonCloudAlbumList = jsonEncode(map);
    LogData().dd(tag, 'jsonCloudAlbumList', jsonCloudAlbumList);
    var back = await HttpConnection().toServer(
        ip: urlIp,
        path: urlServerAlbumPath,
        json: jsonCloudAlbumList,
        headerMap: headerCloudAlbum);
    LogData().dd(tag, "back", back.toString());
    var backCloudAlbumList = jsonDecode(back);
    LogData().dd(tag, "backCloudAlbumList", backCloudAlbumList.toString());
    List<AlbumList> list = [];
    if (backCloudAlbumList.isNotEmpty) {
      LogData().d(tag, "backCloudAlbumList.isNotEmpty");
      LogData()
          .d(tag, "backCloudAlbumList.length :${backCloudAlbumList.length}");
      for (int i = 0; i < backCloudAlbumList.length; i++) {
        list.add(AlbumList.fomJson(backCloudAlbumList[i]));
      }
      albumLists = [];
      albumLists.addAll(list);
      if (cacheHeight <= 0) {
        screenHeight = MediaQuery.of(context).size.height;
        cacheHeight = screenHeight * 1.5;
      }
      getAvatars(albumLists);
      // setState(() {});
    } else
      LogData().d(tag, "backCloudAlbumList.isEmpty");
  }
  Future xxgetAvatars(List<AlbumList> list) async {
    Map<String, String> header = {sAction: sQuery, sContent: sAvatar};
    String json = jsonEncode(list);
    var readAvatar = await HttpConnection().getDatabaseImages(
        ip: urlIp, path: urlServerUserPath, json: json, headerMap: header);
    avatars = [];
    var readList = await jsonDecode(readAvatar);
    for (int i = 0; i < readList.length; i++) {
      TransferImage.fromJson(readList[i]);
    }
  }
    Future getAvatars(List<AlbumList> list) async {
      List<Uint8List> readImages = [];
      for (int i = 0; i < list.length; i++) {
        Map<String, String> header = {sAction: sQuery, sContent: sAvatar};
        Map<String, String> map = {
          sType: sImage,
          sUsername: list[i].username,
        };
        String json = jsonEncode(map);
        Uint8List? readImage = await HttpConnection().getDatabaseImage(
            ip: urlIp, path: urlServerUserPath, json: json, headerMap: header);
        readImages.add(readImage!);
      }
      avatars = [];
      avatars.addAll(readImages);
      setState(() {
      });
    }

}
