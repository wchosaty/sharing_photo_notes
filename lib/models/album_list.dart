import 'package:flutter/foundation.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';

class AlbumList {
  late int id;
  late String album_name;
  late String username;
  late String kind;
  late int status;
  late int update_time;

  AlbumList(
      {this.id = 0,
      required this.album_name,
      required this.username,
      this.kind = '',
      this.status = statusPrivate,
      this.update_time = 0});

  factory AlbumList.fomJson(Map<String, dynamic> parsedJson) {
     return AlbumList(
     id : parsedJson['id'],
    album_name : parsedJson['album_name'],
    username : parsedJson['username'],
    status : parsedJson['status'],
    kind : parsedJson['kind'],
    update_time : parsedJson['update_time']
     );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'album_name': album_name,
        'username': username,
        'status': status,
        'kind': kind,
        'update_time': update_time,
      };
}
