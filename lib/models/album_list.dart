import 'package:sharing_photo_notes/config/model_constants.dart';

class AlbumList {
  late int id;
  late String album_name;
  late String user_name;
  late String kind;
  late int status;
  late int update_time;

  AlbumList(
      {this.id = 0,
      required this.album_name,
      required this.user_name,
      this.kind = '',
      this.status = statusPrivate,
      update_time = 0});

  AlbumList.fomJson(Map<String, dynamic> json)
      : id = json['id'],
        album_name = json['album_name'],
        user_name = json['user_name'],
        status = json['json'],
        kind = json['kind'],
        update_time = json['update_time'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'album_name': album_name,
        'user_name': user_name,
        'status': status,
        'kind': kind,
        'update_time': update_time,
      };
}
