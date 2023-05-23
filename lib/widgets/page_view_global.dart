import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/models/Photo.dart';
import 'package:sharing_photo_notes/models/album.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/models/transfer_image.dart';
import 'package:sharing_photo_notes/utils/http_connection.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';

class PageViewGlobal extends StatefulWidget {
  AlbumList albumList;

  PageViewGlobal({Key? key, required this.albumList}) : super(key: key);


  @override
  State<PageViewGlobal> createState() => _PageViewGlobalState();
}



class _PageViewGlobalState extends State<PageViewGlobal> {
  static const tag = 'tag _PageViewGlobalState';
  late PageController? pageController;
  late Album album;
  late String album_name;
  late String username;
  var viewportFraction = 0.85;
  late List<Photo> photos;
  double? pageOffset = 0;
  late List<TransferImage> transferList;

  @override
  void initState() {
    super.initState();
    pageController =
    PageController(initialPage: 0, viewportFraction: viewportFraction)
      ..addListener(() => setState(() {
        pageOffset = pageController!.page!;
      }));
    print("PageViewGlobal ini");

    initialData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 1, right: 1),
      child: SizedBox(width: 100, height: 100,
        child: PageView.builder(
            controller: pageController,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(3),
                child: Text("${photos[index].album_name}"),
              );
            }),
      )
    );
  }

  Future initialData() async{
    album_name = widget.albumList.album_name;
    username = widget.albumList.username;
    print("album_name : $album_name");
    print("username : $username");
    Map<String, String> headerAlbum = {sAction: sQuery, sContent: sAlbum};
    Map<String, String> map = {sType: sAlbumName, sAlbumName: album_name,sUsername: username};
    String jsonAlbum = jsonEncode(map);
    LogData().dd(tag, 'jsonAlbum', jsonAlbum);
   var back = await HttpConnection().toServer(
       ip: urlIp,
       path: urlServerAlbumPath,
       json: jsonAlbum,headerMap: headerAlbum);
    var backDecode = jsonDecode(back);
    LogData().dd(tag, "backAlbum", backDecode.toString());
   if(backDecode.isNotEmpty){
     LogData().d(tag, "backAlbum.isNotEmpty");
     photos = [];
     var backAlbum = Album.fromJson(backDecode);
     photos.addAll(backAlbum.list);
     setState(() {
     });
   }
  }
}
