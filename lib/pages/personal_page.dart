import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/pages/edit_page.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';
import 'package:sharing_photo_notes/utils/access_file.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';
import 'package:sharing_photo_notes/widgets/page_view_albums.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  static const tag = 'tag _PersonalPageState';
  late List<AlbumList> albumLists;
  late String localUsername;
  late int listSizeLog;
  String result = "";
  late Image avatarWidget;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    albumLists = [];
    localUsername = '';
    listSizeLog = 0;
    avatarWidget = Image.asset(
      imageAccount,
      fit: BoxFit.cover,
      color: Colors.black,
      width: 60,
      height: 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    ///解析換頁帶來資料
    if (MyApp.localUser.isNotEmpty && MyApp.localUser != localUsername) {
      LogData().d(tag, "MyApp.localUser.isNotEmpty");
      initialData();
    }

    return Scaffold(
        backgroundColor: colorBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToEdit(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          margin: const EdgeInsets.all(1),
          child: Stack(children: [
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  SizedBox(
                    height: height,
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.1),
                      child: ListView.builder(
                          itemCount: albumLists.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children : [
                                Container(
                                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: width * 100,
                                        height: 40,
                                        child: Container(
                                          margin: EdgeInsets.only(top: height * 0.01,left: width * 0.3 ),
                                          child: Text(albumLists[i].album_name,
                                              style: const TextStyle(
                                                letterSpacing: 1.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: sFontSizeAlbumName,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              PageViewAlbums(
                                path: "$localUsername/${albumLists[i].album_name}/${albumLists[i].album_name}",
                              ),
                              ],
                            );

                          }),

                    ),
                  ),
                  /// avatar
                  Positioned(
                    top: height * 0.005,
                    left: width * 0.05,
                    child: avatarWidget,
                  ),
                  /// username
                  Positioned(
                    top: height * 0.03,
                    left: width * 0.3,
                    child: Text(
                      MyApp.localUser,
                      style: const TextStyle(
                        color: colorTitle,
                        letterSpacing: dUserLetterSpacing,
                        fontSize: dUserFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                      top: height * 0.02,
                      left: width * 0.85,
                      right: 3,
                      child: InkWell(
                        onTap: () {
                          _logOut();
                        },
                          child: Image.asset(imageLogOut,width: 50,height: 50,))),
                ],
              ),
            ),
          ]),
        ));
  }

  Future initialData() async {
    LogData().d(tag, "initialData");
    localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);

    String avatarPath = "${MyApp.localUser}/$sAvatar.png";
    Directory dir = await AccessFile().getPath(avatarPath, false);
    var file = File("${dir.path}");
    bool exist = await file.exists();
    if (exist) {
      Uint8List temp = await file.readAsBytes();
      avatarWidget = Image.memory(temp, fit: BoxFit.cover,
        width: 60,
        height: 60,);

    }
    getAlbumLists();

  }

  void goToEdit(BuildContext context) async {
    result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditPage()));
    if (result.isNotEmpty) {
        getAlbumLists();
    }
  }

  Future getAlbumLists() async {
    var reaList = await AccessFile().getAlbumLists(localUsername);
    LogData().dd(tag, "reaList length", reaList.length.toString());
    LogData().dd(tag, "listSizeLog length", listSizeLog.toString());
    if (reaList.length != listSizeLog && reaList.length >= 0) {
      LogData().d(tag, "if(reaList)");
        LogData().d(tag, "setState");
        albumLists = reaList;
        listSizeLog = albumLists.length;
    }
    setState(() {});
  }

  Future  _logOut() async{
    preferences = await SharedPreferences.getInstance();
    preferences.setBool(sLogin, false);
    MyApp.localUser = "";
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
