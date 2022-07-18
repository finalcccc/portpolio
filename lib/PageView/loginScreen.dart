// ignore_for_file: use_build_context_synchronously

import 'package:amnong_profile/PageView/InsertProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email!, password: _password!);
      print('User: $userCredential');
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password!);
      print('User: $userCredential');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InsertProfile()));
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    }
  }

  String? _email;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: const InputDecoration(hintText: "ອີເມວ"),
            ),
            TextField(
              onChanged: (value) {
                _password = value;
              },
              decoration: const InputDecoration(hintText: "ລະຫັດຜ່ານ"),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () => _login(),
                      child: const Text('Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () => _createUser(),
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  // Future<void> addData() async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .add({'name': "amnong", 'address': 'hjdjfjjdjf'});
  // }
}
