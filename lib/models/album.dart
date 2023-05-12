import 'package:sharing_photo_notes/models/Photo.dart';

class Album {
  String album_name;
  String username;
  String note;
  String kind;
  List<Photo> list;

  Album(
      {this.album_name = '',
      this.username = '',
      this.note = '',
      required this.list,
      this.kind = ''});

  Map<String, dynamic> toJson() => {
        'album_name': album_name,
        'username': username,
        'kind': kind,
        'list': list,
        'note': note,
      };

  factory Album.fromJson(Map<String, dynamic> parseJson) {
    var listFromJson = parseJson['list'] as List;
    List<Photo> photoList =
        listFromJson.map((index) => Photo.fromJson(index)).toList();
    return Album(
      album_name: parseJson['album_name'],
      username: parseJson['username'],
      list: photoList,
      note: parseJson['note'],
      kind: parseJson['kind'],
    );
  }
}
