import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/message_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/string_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/Photo.dart';
import 'package:sharing_photo_notes/models/album.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/models/transfer_image.dart';
import 'package:sharing_photo_notes/utils/access_file.dart';
import 'package:sharing_photo_notes/utils/http_connection.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';
import 'package:sharing_photo_notes/widgets/com_text_field.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  static const tag = 'tag _EditPageState';
  late List<XFile> images;
  late List<Photo> list;
  late List<AlbumList> albumLists;
  late String albumName;
  late String note;
  late TextEditingController albumNameController;
  late TextEditingController noteController;
  late PageController? pageController;
  var viewportFraction = 0.8;
  String localUsername = '';
  double? pageOffset = 0;

  @override
  void initState() {
    super.initState();

    albumName = '';
    note = '';
    images = [];
    albumLists = [];
    albumNameController = TextEditingController();
    noteController = TextEditingController();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() => setState(() {
                pageOffset = pageController!.page!;
              }));
  }

  @override
  Widget build(BuildContext context) {
    if ( (MyApp.localUser.isNotEmpty) && (MyApp.localUser != localUsername )) {
      LogData().d(tag, "MyApp.localUser.isNotEmpty");
      initialData();
    }
    final screenWidth = MediaQuery.of(context).size.width * 0.01;
    final screenHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          sEditPhoto,
          style: TextStyle(
              color: colorTitle,
              letterSpacing: dTitleLetterSpacing,
              fontSize: dTitleFontSize,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.all(1),
        child: Padding(
          padding: EdgeInsets.all(screenWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ComTextField(
                labelText: sHintAlbum,
                controller: albumNameController,
                maxLength: 20,
              ),
              ComTextField(
                labelText: sHintNote,
                controller: noteController,
                maxLength: 50,
              ),
              SizedBox(
                width: screenWidth * 100,
                height: screenHeight * 50,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      ///Image縮小Max為螢幕高度的15%
                      double imageScaleHeight = screenHeight * 15;
                      double heightOffset = (pageOffset! - index).abs();

                      /// 分三部分 : 不縮高度 縮:1 縮:2
                      double subTimes = imageScaleHeight;
                      double baseOffset = subTimes / 10;
                      heightOffset *= subTimes / 2;
                      if (heightOffset > imageScaleHeight)
                        heightOffset = imageScaleHeight;

                      /// shift describe
                      return Padding(
                        padding: EdgeInsets.only(
                            top: baseOffset + heightOffset,
                            bottom: screenHeight,
                            left: screenWidth,
                            right: screenWidth),
                        child: Transform(
                          transform: Matrix4.identity()..setEntry(3, 2, 0.001),
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              child: Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// 返回
                      InkWell(
                        onTap: () {},
                        radius: dIconSize / 2,
                        splashColor: colorClick,
                        child: Image.asset(
                          imageUndoPhoto,
                          width: dIconSize,
                          height: dIconSize,
                          fit: BoxFit.cover,
                          color: colorIcon,
                        ),
                      ),

                      /// 選照片
                      InkWell(
                        onTap: () {
                          _getImages();
                        },
                        radius: dIconSize / 2,
                        splashColor: colorClick,
                        child: Image.asset(
                          imageAddPhoto,
                          width: dIconSize,
                          height: dIconSize,
                          fit: BoxFit.cover,
                          color: colorIcon,
                        ),
                      ),

                      /// 刪除單張照片
                      InkWell(
                          onTap: () {
                            _deleteImage();
                          },
                          radius: dIconSize / 2,
                          splashColor: colorClick,
                          child: Image.asset(
                            imageDeletePhoto,
                            width: dIconSize,
                            height: dIconSize,
                            fit: BoxFit.cover,
                            color: colorIcon,
                          )),

                      /// 清除相簿
                      InkWell(
                        onTap: () {
                          _removeAllImage();
                        },
                        radius: dIconSize / 2,
                        splashColor: colorClick,
                        child: Image.asset(
                          imageRemovePhoto,
                          width: dIconSize,
                          height: dIconSize,
                          fit: BoxFit.cover,
                          color: colorIcon,
                        ),
                      ),

                      /// 上傳
                      InkWell(
                        onTap: () {
                          if (_checkAlbum()) {
                            _uploadAlbum();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                              mPhotosEditEmpty,
                              style: TextStyle(fontSize: fontSizeSnackBar),
                            )));
                          }
                        },
                        radius: dIconSize / 2,
                        splashColor: colorClick,
                        child: Image.asset(
                          imageUploadPhoto,
                          width: dIconSize,
                          height: dIconSize,
                          fit: BoxFit.cover,
                          color: colorIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImages() async {
    /// 可調整來源圖片
    var selectImage = await ImagePicker()
        .pickMultiImage(maxWidth: 1080, maxHeight: 1080, imageQuality: 70);
    if (selectImage.isNotEmpty) {
      images.addAll(selectImage);
    }
    setState(() {});
  }

  void _deleteImage() {
    var index = pageController?.page?.toInt();
    images.removeAt(index!);
    setState(() {});
  }

  void _removeAllImage() {
    images = [];
    setState(() {});
  }

  bool _checkAlbum() {
    bool flag = false;
    albumName = albumNameController.text.trim();
    note = noteController.text.trim();
    if (checkString(albumName) && checkString(note) && (images.isNotEmpty))
      flag = true;
    return flag;
  }

  bool checkString(String s) {
    bool flag = false;
    if (s.trim().isNotEmpty) flag = true;
    return flag;
  }

  Future<void> _uploadAlbum() async {
      print("MyApp.localUser : ${MyApp.localUser}");
      print("localUsername : ${localUsername}");
      LogData().dd(tag, "uploadAlbum MyApp.localUser",MyApp.localUser);
    String albumName = albumNameController.text.trim();
    String note = noteController.text.trim();
    List<Photo> list = [];
    int id = DateTime.now().microsecondsSinceEpoch;
    Directory directoryUsername = await AccessFile().getPath(localUsername, true);
    String dirAlbum = "$localUsername/$albumName";
    Directory directoryAlbum = await AccessFile().getPath(dirAlbum, true);
    /// "$localUsername/$albumName/${id.toString()}.png";
    List<TransferImage> transferList = [];
    for (int i = 0; i < images.length; i++) {
      Uint8List image = await images[i].readAsBytes();
      int image_name = (id + i);
      Photo photo = Photo(
          note: note,
          album_name: albumName,
          id: image_name,
          image_path: '${directoryAlbum.path}/${(id + i)}.png');
      list.add(photo);
      TransferImage transfer = TransferImage(
          image: image, image_name: image_name, username: localUsername);
      transferList.add(transfer);
    }

    /// upload 不包含image
    Album album = Album(
        list: list, album_name: albumName, username: localUsername, note: note);
    Map<String, String> headerAlbum = {sAction: sInsert, sContent: sAlbum};
    String jsonAlbum = jsonEncode(album);
    LogData().dd(tag, 'jsonAlbum', jsonAlbum);
    String backAlbum = await HttpConnection().toServer(
        ip: urlIp,
        path: urlServerAlbumPath,
        json: jsonAlbum,
        headerMap: headerAlbum);
    if (backAlbum.isNotEmpty) {
      LogData().d(tag, 'back.isNotEmpty');
      AlbumList albumList = AlbumList(
          album_name: albumName,
          username: localUsername,
          id: id,
          status: statusPublic,
          kind: sEmpty);
      String jsonAlbumList = jsonEncode(albumList);
      LogData().dd(tag, 'jsonAlbumList', jsonAlbumList);
      Map<String, String> headerAlbumList = {
        sAction: sInsert,
        sContent: sAlbumList
      };
      String backJsonAlbumList = await HttpConnection().toServer(
          ip: urlIp,
          path: urlServerAlbumPath,
          json: jsonAlbumList,
          headerMap: headerAlbumList);
      if (backJsonAlbumList.isNotEmpty) {
        LogData().d(tag, "backJsonAlbumList");
        String jsonTransfer = jsonEncode(transferList);
        LogData().dd(tag, "jsonTransferImages", jsonTransfer);
        Map<String, String> headerTransferImage = {
          sAction: sInsert,
          sContent: sImages,
        };
        String backTransferImage = await HttpConnection().toServer(
            ip: urlIp,
            path: urlServerAlbumPath,
            json: jsonTransfer,
            headerMap: headerTransferImage);
        if (backTransferImage.isNotEmpty) {
          print("backTransferImage.isNotEmpty");
          await saveFile(album, albumList);
          Navigator.pop(context,sCreate);
        }
      }
    }
  }

  Future<void> saveFile(Album album, AlbumList albumList) async {
    Album albumEdit = album;
    Directory dirUsername = await AccessFile().getPath(localUsername, true);
    File fileAlbumList = File("${dirUsername.path}/$sAlbumList");
    String temp = "${localUsername}/${albumName}";
    Directory dirAlbumName = await AccessFile().getPath(temp, true);
    LogData().dd(tag, "images/album.list length", "${images.length}/${album.list.length}");

    /// save image
    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i].path);
      await imageFile.copy("${album.list[i].image_path}");
    }

    /// save album
    var file = File("${dirAlbumName.path}/$albumName");
    String json = jsonEncode(albumEdit);
    file.writeAsString(json);

    /// save albumLists
    albumLists = await AccessFile().getAlbumLists(localUsername);
    LogData().dd(tag, "albumListsRead length", albumLists.length.toString());
    albumLists.add(albumList);
    String writeString = jsonEncode(albumLists);
    fileAlbumList.writeAsString(writeString);
  }

  Future initialData() async {
    localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);
  }
}
