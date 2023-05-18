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
  var viewportFraction = 0.85;
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
    initialData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 1, right: 1),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("data"),
          SizedBox(width: 100,height: 100,),
        ],),
    );
  }

  Future initialData() async{
    album_name = widget.albumList.album_name;
    Map<String, String> headerAlbum = {sAction: sQuery, sContent: sAlbum};
    Map<String, String> map = {sType: sAlbumName, sAlbumName: album_name};
    String jsonQuery = jsonEncode(map);
   var backAlbum = await HttpConnection().toServer(
       ip: urlIp,
       path: urlServerAlbumPath,
       json: jsonQuery,headerMap: headerAlbum);
   if(backAlbum.isNotEmpty){
     LogData().d(tag, "backAlbum.isNotEmpty");
   }
  }
}
