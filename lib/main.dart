import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'PageView/loginScreen.dart';
import 'package:flutter/foundation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDY-iFzH1iXdiEq22hbtq0GXCg-oB1UDCU",
      appId: "1:658377314346:web:b00b5be6fda4b23d1df353",
      messagingSenderId: "658377314346",
      projectId: "amnong-profile",
      storageBucket: "myapp.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
