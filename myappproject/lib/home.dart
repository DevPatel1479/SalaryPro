import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? Key}) : super(key: Key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
    );
  }
}
