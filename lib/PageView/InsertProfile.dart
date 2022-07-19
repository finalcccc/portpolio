// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:amnong_profile/PageView/fetchProfile.dart';
import 'package:amnong_profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

class InsertProfile extends StatefulWidget {
  const InsertProfile({Key? key}) : super(key: key);

  @override
  State<InsertProfile> createState() => _InsertProfileState();
}

class _InsertProfileState extends State<InsertProfile> {
  String? img;
  TextEditingController nameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController birtdayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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

  Future<String> uptoSt() async {
    Reference ref =
        await FirebaseStorage.instance.ref('image').child(_cloudFile!.name);
    await ref.putData(_fileBytes, SettableMetadata(contentType: 'image/png'));
    String url = await ref.getDownloadURL();

    // String url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Polio Page'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  getMultipleImageInfos();
                },
                child: Column(
                  children: [
                    _fileBytes != null
                        ? Image.memory(
                            _fileBytes,
                            height: 100,
                            width: 120,
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'ຊື່ ແລະ ນາມສະກຸນ'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: telController,
                decoration: const InputDecoration(hintText: 'ເບີໂທ'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: birtdayController,
                decoration: const InputDecoration(hintText: 'ວັນເດືອນປີເກີດ'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'ລາຍລະອຽດ'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    List<userModel> allUser = await addUser(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FetchProfile(
                                  user: allUser,
                                )));
                  },
                  child: const SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'ບັນທຶກ',
                          style: TextStyle(fontSize: 20),
                        ),
                      )))
            ],
          ),
        ));
  }

  Future<List<userModel>> addUser(context) async {
    String images = await uptoSt();
    List<userModel> users = [];
    int random = await Random().nextInt(100);
    final user = userModel(
      id: random.toString(),
      name: nameController.text,
      tel: telController.text,
      birthday: birtdayController.text,
      description: descriptionController.text,
      image: images,
    );
    final docUser =
        FirebaseFirestore.instance.collection('user').doc(random.toString());
    await docUser.set(user.tojson()).then((value) async {
      QuerySnapshot<Map<String, dynamic>> rfn =
          await FirebaseFirestore.instance.collection('user').get();
      for (var element in rfn.docs) {
        userModel authUser = userModel.fromJson(element.data());
        users.add(authUser);
        print(authUser.name);
      }
    });
    return users;
  }
}
