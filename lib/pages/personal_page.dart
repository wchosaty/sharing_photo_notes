import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/models/user.dart';
import 'package:sharing_photo_notes/utils/initialData.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late List<AlbumList> albumLists;
  late String localUsername;

  @override
  void initState() {
    super.initState();
    albumLists = [];
    localUsername = '';
  }

  @override
  Widget build(BuildContext context) {
    String test = '0';

    ///解析換頁帶來資料
    if (ModalRoute.of(context)?.settings.arguments != null) {
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
          margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(1),
          child: ListView.builder(itemBuilder: itemBuilder),
        ));
  }

  Future initialData() async {
    localUsername = ModalRoute.of(context)?.settings.arguments as String;
  }
}
