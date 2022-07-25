// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import '../models/user_model.dart';
import 'dart:html' as html;
import 'dart:io' as io;
import 'package:path/path.dart' as Path;

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

  html.File? _cloudFile;
  var _fileBytes;

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String? mimeType = mime(Path.basename(mediaData!.fileName ?? ''));
    html.File mediaFile = html.File(
        mediaData.data!.toList(), mediaData.fileName ?? '', {'type': mimeType});

    setState(() {
      _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
    });
  }

  Future<String> uptoSt(userModel users) async {
    List<String> imageName;
    imageName = await users.image.split('/');
    imageName = await imageName[7].split('F');
    imageName = await imageName[1].split('?');
    print(imageName);
    print('=====================================================');
    Reference ref = await FirebaseStorage.instance
        .ref('image')
        .child(imageName[0].toString());
    await ref.putData(_fileBytes, SettableMetadata(contentType: 'image/png'));
    String url = await ref.getDownloadURL();
    return url;
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
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Image.network(
                          user[index].image,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
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
          title: const Text('ແກ້ໄຂຂໍ້ມູນ'),
          titleTextStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                    child: _fileBytes != null
                        ? Image.memory(
                            _fileBytes,
                            height: 100,
                            width: 120,
                          )
                        : Image.network(
                            users.image,
                            width: 100,
                            height: 100,
                          ),
                    onTap: () async {
                      await getMultipleImageInfos();
                      Navigator.pop(context);
                      _showMyDialog(users, context);
                    },
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
            ],
          )),
          actions: <Widget>[
            TextButton(
              child: const Center(
                child: Text(
                  'ບັນທຶກ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              onPressed: () async {
                users.image = await uptoSt(users);
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
