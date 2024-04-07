import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myappproject/home.dart';
import 'phone.dart';
import 'verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDO35DmRLKg28x7GsvjQR0ahSExU03pRZM',
              appId: '1:102393392944:android:b810eefb1681c64df5a2f5',
              messagingSenderId: '102393392944',
              projectId: 'myappprojecthack'))
      : await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone': (context) => MyPhone(),
      'verify': (context) => MyVerify(),
      'home': (context) => MyHome(),
    },
  ));
}
