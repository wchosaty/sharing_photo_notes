import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/utils/access_album_lists.dart';
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

  @override
  void initState() {
    super.initState();
    albumLists = [];
    localUsername = '';
    listSizeLog = 0;
  }

  @override
  Widget build(BuildContext context) {
    ///解析換頁帶來資料
    // if (ModalRoute.of(context)?.settings.arguments != null) {
    //   LogData().d(tag, "Widget build");
    //   initialData();
    // }
    if (MyApp.localUser.isNotEmpty && MyApp.localUser != localUsername) {
      LogData().d(tag, "MyApp.localUser.isNotEmpty");
      initialData();
    }

    return Scaffold(
        backgroundColor: colorBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/Edit', arguments: localUsername);
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          margin: const EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: albumLists.length,
              itemBuilder: (context, i) {
                return PageViewAlbums(path: "$localUsername/${albumLists[i].album_name}/${albumLists[i].album_name}",
                );
              }),
        ));
  }

  Future initialData() async {
    LogData().d(tag, "initialData");
    // localUsername = ModalRoute.of(context)?.settings.arguments as String;
      localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);
    var reaList = await AccessAlbumLists.getAlbumLists(localUsername);
    LogData().dd(tag, "reaList length", reaList.length.toString());
    LogData().dd(tag, "listSizeLog length", listSizeLog.toString());
    if (reaList.length != listSizeLog && reaList.length >= 0) {
      LogData().d(tag, "if(reaList)");
      setState(() {
        LogData().d(tag, "setState");
        albumLists = reaList;
        listSizeLog = albumLists.length;
      });
    }
  }
}
