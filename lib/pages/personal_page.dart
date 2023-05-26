import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/config/string_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
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

  @override
  void initState() {
    super.initState();
    albumLists = [];
    localUsername = '';
    listSizeLog = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("personal build");
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
      localUsername = MyApp.localUser;
    LogData().dd(tag, "localUsername", localUsername);
    getAlbumLists();
  }

  void goToEdit(BuildContext context) async{
    var status = await Navigator.pushNamed(context,'/Edit');
    if(status != null) {
      LogData().dd(tag, "goToEdit","$status");
      print("goToEdit : $status");
      getAlbumLists();
    }
  }
  Future getAlbumLists() async{
    var reaList = await AccessFile().getAlbumLists(localUsername);
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
