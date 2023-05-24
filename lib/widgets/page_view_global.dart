import 'dart:convert';
import 'dart:typed_data';

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
  late List<Uint8List> images;
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
    photos = [];
    images = [];
    initialData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 1, right: 1),
      child: Column(
        children: [
          Text(album_name),
          SizedBox(width: 200, height: 200,
            child: PageView.builder(
                controller: pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  Map<String,String> header = {sAction: sQuery, sContent: sAlbum};
                  Map<String, String> map = {sType: sImage, sAlbumName: album_name,sUsername: username, sImageName: photos[index].id.toString()};
                  String json = jsonEncode(map);
                  LogData().dd(tag, "json", json);
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.memory(images[index],width: 50,height: 50,),
                  );
                }),
          ),
        ],
      )
    );
  }

  Future initialData() async{
    album_name = widget.albumList.album_name;
    username = widget.albumList.username;
    print("album_name : $album_name");
    print("username : $username");
    Map<String, String> headerAlbum = {sAction: sQuery, sContent: sAlbum};
    Map<String, String> map = {sType: sAlbum, sAlbumName: album_name,sUsername: username};
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
     getImage();
   }
  }

  Future getImage() async {
    List<Uint8List> readImages = [];
    for(int i=0; i < photos.length; i++){
      Map<String,String> header = {sAction: sQuery, sContent: sAlbum};
      Map<String, String> map = {sType: sImage, sAlbumName: album_name,sUsername: username, sImageName: photos[i].id.toString()};
      String json = jsonEncode(map);
      Uint8List? readImage = await HttpConnection().getDatabaseImage(ip: urlIp, path: urlServerAlbumPath,json: json,headerMap: header);
      readImages.add(readImage!);
    }
    images = [];
    setState(() {
      images.addAll(readImages);
    });
  }
}
