import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/models/album_list.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';

class AccessAlbumLists {
  static const tag = 'tag AccessAlbumLists';

  static Future<List<AlbumList>> getAlbumLists(String username) async {
    Directory dirUsername = await getPath(username,true);
    var file = File("${dirUsername.path}/$sAlbumList");
    List<AlbumList> list = [];
    bool exist = await file.exists();
    if (exist) {
      LogData().d(tag, "List<AlbumList> exist");
      String temp = await file.readAsString();
      List<dynamic> readAlbumLists = jsonDecode(temp);
      for (int i = 0; i < readAlbumLists.length; i++) {
        list.add(AlbumList.fomJson(readAlbumLists[i]));
      }
      LogData().dd(tag, "list.length", list.length.toString());
    }
    return list;
  }

  static Future<Directory> getPath(String dirName,bool createFlag) async {
    final dirSource = await getApplicationDocumentsDirectory();
    final dirPath = Directory('${dirSource.path}/$dirName');
    bool exist = await dirPath.exists();
    if (!exist) {
      if(createFlag) await dirPath.create();
    }
    return dirPath;
  }
}
