import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'PageView/InsertProfile.dart';
import 'PageView/loginScreen.dart';
import 'package:flutter/foundation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC-dTSDRqS7mevbjDVEF3RI6H_VIyb8gx0",
        authDomain: "kkkkk-1eca5.firebaseapp.com",
        projectId: "kkkkk-1eca5",
        storageBucket: "kkkkk-1eca5.appspot.com",
        messagingSenderId: "946042886688",
        appId: "1:946042886688:web:28e1bb880d84d241c93a45",
        measurementId: "G-118PRTW1JE"
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
      home:  InsertProfile(),
    );
  }
}
