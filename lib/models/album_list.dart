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

  AlbumList.fomJson(Map<String, dynamic> json)
      : id = json['id'],
        album_name = json['album_name'],
        username = json['username'],
        status = json['status'],
        kind = json['kind'],
        update_time = json['update_time'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'album_name': album_name,
        'username': username,
        'status': status,
        'kind': kind,
        'update_time': update_time,
      };
}
