import 'dart:typed_data';

class Photo {
  late int id;
  late int last_time;
  late String album_name;
  late String note;
  late String image_path;
  // late Uint8List image;

  Photo({
    this.id = 0,
    this.last_time = 0,
    this.album_name = '',
    this.note = '',
    this.image_path = "",
    // required this.image,
  });

  Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        // image = json['image'],
        album_name = json['album_name'],
        note = json['note'],
        last_time = json['last_time'],
        image_path = json['image_path'];

  Map<String, dynamic> toJson() => {
        'id': id,
        // 'image': image,
        'note': note,
        'album_name': album_name,
        'last_time': last_time,
        'image_path': image_path,
      };
}
