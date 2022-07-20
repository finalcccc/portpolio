// ignore_for_file: no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

class FetchProfile extends StatefulWidget {
  List<userModel> user;
  FetchProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<FetchProfile> createState() => _FetchProfileState(this.user);
}

class _FetchProfileState extends State<FetchProfile> {
  List<userModel> user = [];

  _FetchProfileState(this.user) {
    user = this.user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fetch Data Profile"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: user.length,
            itemBuilder: (BuildContext context, int index) {
              print(user[index].image);
              return SafeArea(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: Image.network(
                            user[index].image.toString(),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user[index].name.toString()),
                            Text(user[index].tel),
                            Text(user[index].birthday),
                            Text(user[index].description),
                            const Text(
                                'ສະບາຍດີ ຂ້ອຍຊື່ ທ້າວ ອຳນົງ ໄຊຈື່ວ່າງ ຂ້ອຍມາຈາກແຂວງຫົວພັນ'),
                            const SizedBox(height: 60),
                            ElevatedButton(
                                onPressed: () {
                                  _showMyDialog(user[index], context);
                                },
                                child: const Text('ແກ້ໄຂຂໍ້ມູນ'))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ));
            }));
  }

  Future<void> _showMyDialog(userModel users, context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('title'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: users.name,
                  onChanged: (value) {
                    users.name = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: users.tel,
                  onChanged: (value) {
                    users.tel = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: users.birthday,
                  onChanged: (value) {
                    users.birthday = value.trim();
                  },
                ),
                TextFormField(
                  initialValue: users.description,
                  onChanged: (value) {
                    users.description = value.trim();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Center(
                child: Text('Approve'),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(users.id)
                    .update(users.tojson())
                    .then((value) async {
                  user.clear();
                  QuerySnapshot<Map<String, dynamic>> rfn =
                      await FirebaseFirestore.instance.collection('user').get();
                  rfn.docs.forEach((element) async {
                    userModel authUser =
                        await userModel.fromJson(element.data());
                    user.add(authUser);
                    print(authUser.name);
                  });
                });
                setState(() {
                  user;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
