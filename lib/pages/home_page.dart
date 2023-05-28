import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/pages/browse_page.dart';

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
  final pages = [BrowsePage(), PersonalPage()];

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
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30, selectedFontSize : 0, unselectedFontSize : 0,elevation: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document,), label: ''),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemClick,
      ),
      body: SafeArea(
        child: Container(
          child: pages[_currentIndex],
        ),
      ),
    );
  }

  void _onItemClick(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
