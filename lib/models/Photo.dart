import 'dart:typed_data';

class Photo {
  late int id;
  Uint8List image = Uint8List(0);
  late String title;
  late String describe;
  late int last_time;
  late String imagePath;

  Photo(
      {required this.id,
      this.title = '',
      this.describe = '',
      last_time = 0,
      this.imagePath = ""});

  Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        title = json['title'],
        describe = json['describe'],
        last_time = json['last_time'],
        imagePath = json['imagePath'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'describe': describe,
        'last_time': last_time,
      };
}
