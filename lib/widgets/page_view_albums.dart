import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/models/Photo.dart';
import 'package:sharing_photo_notes/models/album.dart';
import 'package:sharing_photo_notes/utils/access_album_lists.dart';

class PageViewAlbums extends StatefulWidget {
  final String path;

  const PageViewAlbums({Key? key, required this.path}) : super(key: key);

  @override
  State<PageViewAlbums> createState() => _PageViewAlbumsState();
}

class _PageViewAlbumsState extends State<PageViewAlbums> {
  static const tag = 'tag _PageViewAlbumsState';
  late PageController? pageController;
  late Album album;
  late List<Uint8List> images;
  var viewportFraction = 0.85;
  double? pageOffset = 0;
  List<Photo> viewList = [];

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(top: 10,bottom: 10),
      child: SizedBox(
        width: width * 0.95,
        height: height * 0.5,
        child: PageView.builder(
            controller: pageController,
            itemCount: viewList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Transform(
                  transform: Matrix4.identity()..setEntry(3, 2, 0.001),
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Image.file(
                        File(viewList[index].image_path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future initialData() async {
    Directory dir = await AccessAlbumLists.getPath(widget.path, false);
    var file = File("${dir.path}");
    bool exist = await file.exists();
    if (exist) {
      String temp = await file.readAsString();
      Map<String, dynamic> backMap = await jsonDecode(temp);
      album = Album.fromJson(backMap);
      print("path : ${album.list[0].image_path}");
      if (album.list.isNotEmpty && album.list.length > 0) {
        setState(() {
          viewList = album.list;
        });
      }
    }
  }
}
