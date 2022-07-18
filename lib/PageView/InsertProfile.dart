// ignore_for_file: use_build_context_synchronously

import 'dart:html';
import 'dart:math';

import 'package:amnong_profile/PageView/fetchProfile.dart';
import 'package:amnong_profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';

import 'package:path/path.dart' as p;

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
                  imagePicker();
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
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

  Future<MediaInfo?> imagePicker() async {
    MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo;
  }
  //
  // Future<Uri> uploadFile(
  //     MediaInfo mediaInfo, String ref, String fileName) async {
  //   try {
  //     String mimeType = mime(Path.basename(mediaInfo.fileName));
  //     final String extension = extensionFromMime(mimeType);
  //     var metadata = FirebaseStorage.UploadMetadata(
  //       contentType: mimeType,
  //     );
  //     fb.StorageReference storageReference =
  //         fb.storage().ref(ref).child(fileName + ".$extension");
  //
  //     fb.UploadTaskSnapshot uploadTaskSnapshot =
  //         await storageReference.put(mediaInfo.data, metadata).future;
  //     Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
  //     print("download url $imageUri");
  //     return imageUri;
  //   } catch (e) {
  //     print("File Upload Error $e");
  //     return null;
  //   }
  // }

  Future<List<userModel>> addUser(context) async {
    List<userModel> users = [];
    int random = await Random().nextInt(100);
    final user = userModel(
      id: random.toString(),
      name: nameController.text,
      tel: telController.text,
      birthday: birtdayController.text,
      description: descriptionController.text,
    );
    final docUser =
        FirebaseFirestore.instance.collection('user').doc(random.toString());
    await docUser.set(user.tojson()).then((value) async {
      QuerySnapshot<Map<String, dynamic>> rfn =
          await FirebaseFirestore.instance.collection('user').get();
      rfn.docs.forEach((element) {
        userModel authUser = userModel.fromJson(element.data());
        users.add(authUser);
        print(authUser.name);
      });
    });
    return users;
  }
}
