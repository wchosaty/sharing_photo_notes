import 'dart:typed_data';

class TransferImage {
  late String username;
  late int image_name;
  late Uint8List image;

  TransferImage(
      {required this.image, required this.image_name, required this.username});

  TransferImage.fromJson(Map<String, dynamic> json)
      : image_name = json['image_name'],
        image = json['image'],
        username = json['username'];

  Map<String, dynamic> toJson() => {
        'image_name': image_name,
        'image': image,
        'username': username,
      };
}
