import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/pages/browse_page.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';

import 'personal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const tag = 'tag _HomePageState';
  late Widget currentPage;
  int _currentIndex = 0;
  final pages = [BrowsePage(),PersonalPage()];

  @override
  void initState() {
    currentPage = PersonalPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      /// BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Browse'),
        BottomNavigationBarItem(icon: Icon(Icons.edit_document),label: 'Edit'),
      ],
        currentIndex: _currentIndex,
        onTap: _onItemClick,
      ),
      body: SafeArea(child: Container(child: pages[_currentIndex],),),
    );
  }
  void _onItemClick(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
