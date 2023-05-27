import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/models/Photo.dart';
import 'package:sharing_photo_notes/models/album.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
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
  var viewportFraction = 0.8;
  double? pageOffset = 0;
  late List<Photo> photos;
  late List<Uint8List> images;
  late Uint8List avatar;
  // late List<TransferImage> transferList;

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() => setState(() {
                pageOffset = pageController!.page!;
              }));
    photos = [];
    images = [];

    initialData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.01;
    final height = MediaQuery.of(context).size.height * 0.01;
    return Container(
        margin: const EdgeInsets.only(top: 1, bottom: 1),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1,bottom: 1),
              child: Stack(
                children:[ 
                  SizedBox(width: width * 100 , height: 50,),
                  Positioned(
                    top: 3,
                    left: width ,
                    bottom: 3,
                    child:
                    // avatar != null?
                    // Image.memory(avatar,fit: BoxFit.cover,width: 50,height: 50,)
                    //     :
                    Image.asset(
                      imageAccount,
                      fit: BoxFit.cover,
                      color: Colors.black,)
                  ),
                  Positioned(
                    top: 5,
                    left: width * 15,
                      child: Text(username,
                          style: const TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black,
                            fontSize: sFontSizeAlbumUsername,
                          )
                      ),),
                  Positioned(
                    bottom: 0,
                    left: width * 40,
                    child: Text(album_name,
                        style: const TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: sFontSizeAlbumName,
                        )
                    ),),
                ]
              ),
            ),
            SizedBox(
              width: width * 100 ,
              height: height * 45,
              child:
              PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    double angle = (pageController!.page! - index ) * 0.7;
                    double heightOffset = (pageOffset! - index).abs();
                    double maxScaleHeight = height * 15;
                    double scaleHeight = heightOffset * height * 5;
                    if(scaleHeight > maxScaleHeight) scaleHeight = maxScaleHeight;
                    scaleHeight  += height * 3;
                    double bottomHeight = height * 4;
                    return Container(
                      margin: const EdgeInsets.only(top: 1,bottom: 1),
                      child: Padding( padding: EdgeInsets.only(
                            top: scaleHeight , bottom: bottomHeight),
                        child: Transform(
                          transform: Matrix4.identity()..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.white,
                            elevation: 15,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            child: Material(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: width * 100 ,
                                      height: height * 45,
                                      child: Image.memory(
                                      images[index],
                                      fit: BoxFit.cover,
                                  ),),
                                    Positioned(
                                        bottom: 0, left: 0, right: 0,
                                        child: AnimatedOpacity(
                                          /// 0是透明
                                          opacity: angle == 0 ? 1 : 0,
                                          duration: const Duration(milliseconds: 100),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 10, left: 25, right: 10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(0.01),
                                                    Colors.black.withOpacity(0.20),
                                                    Colors.black.withOpacity(0.55),
                                                    Colors.black.withOpacity(0.75),
                                                  ]
                                              )
                                            ),
                                            child: Text(photos[index].note,
                                                style: const TextStyle(
                                                  letterSpacing: 1.3,
                                                  color: colorNote,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: sFontSizeNote,
                                                  height: 1.3,
                                                )),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }



  Future initialData() async {
    album_name = widget.albumList.album_name;
    username = widget.albumList.username;
    final ByteData bytes = await rootBundle.load(imageAccount);
    avatar = bytes.buffer.asUint8List();

    Map<String, String> headerAlbum = {sAction: sQuery, sContent: sAlbum};
    Map<String, String> map = {
      sType: sAlbum,
      sAlbumName: album_name,
      sUsername: username
    };
    String jsonAlbum = jsonEncode(map);
    LogData().dd(tag, 'jsonAlbum', jsonAlbum);
    var back = await HttpConnection().toServer(
        ip: urlIp,
        path: urlServerAlbumPath,
        json: jsonAlbum,
        headerMap: headerAlbum);
    var backDecode = jsonDecode(back);
    LogData().dd(tag, "backAlbum", backDecode.toString());
    if (backDecode.isNotEmpty) {
      LogData().d(tag, "backAlbum.isNotEmpty");
      photos = [];
      var backAlbum = Album.fromJson(backDecode);
      photos.addAll(backAlbum.list);
      // setState(() {});
      getImage();
    }
  }
  Future getAvatar() async {
    Map<String, String> headerAvatar = {sAction: sQuery, sContent: sUser};
    Map<String, String> mapAvatar = {
      sType: sAvatar,
      sUsername: username,
    };
    String json = jsonEncode(mapAvatar);
    Uint8List? readAvatar = await HttpConnection().getDatabaseImage(
        ip: urlIp, path: urlServerUserPath, json: json, headerMap: headerAvatar);
    avatar = readAvatar!;
  }
  Future getImage() async {
    List<Uint8List> readImages = [];
    for (int i = 0; i < photos.length; i++) {
      Map<String, String> header = {sAction: sQuery, sContent: sAlbum};
      Map<String, String> map = {
        sType: sImage,
        sAlbumName: album_name,
        sUsername: username,
        sImageName: photos[i].id.toString()
      };
      String json = jsonEncode(map);
      Uint8List? readImage = await HttpConnection().getDatabaseImage(
          ip: urlIp, path: urlServerAlbumPath, json: json, headerMap: header);
      readImages.add(readImage!);
    }
    images = [];
    images.addAll(readImages);
    setState(() {
    });
  }
}
