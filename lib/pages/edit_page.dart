import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/models/Photo.dart';
import 'package:sharing_photo_notes/widgets/com_text_field.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late List<Photo> list;
  late Uint8List photos;
  late String albumName;
  late String title;
  late String describe;
  TextEditingController albumNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController describeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    albumName = '';
    title = '';
    describe = '';
  }

  @override
  Widget build(BuildContext context) {
    final screenSide = MediaQuery.of(context).size.width * 0.05;
    final screenHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit',
        style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.all(screenSide),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageView(),
              ComTextField(
                  labelText: albumName, controller: albumNameController),
              ComTextField(labelText: title, controller: titleController),
              ComTextField(labelText: describe, controller: describeController),
            ],
          ),
        ),
      ),
    );
  }
}
