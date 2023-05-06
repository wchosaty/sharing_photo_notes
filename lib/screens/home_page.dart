import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    Page s;
    currentPage = LoginPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    Widget currentPage = LoginPage();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: currentPage,
        ),
      ),
    );
}

