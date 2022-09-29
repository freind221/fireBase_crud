import 'dart:io';

import 'package:fire_learn/utilis/toast_message.dart';
import 'package:fire_learn/utilis/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool loading = false;
  final database = FirebaseDatabase.instance.ref('Post');
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  File? _image;
  final ImagePicker imagePicker = ImagePicker();
  Future getImage() async {
    final picedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picedImage != null) {
      Utils.toatsMessage('Image Picked');
      setState(() {});
      _image = File(picedImage.path);
    } else {
      Utils.toatsMessage("No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(border: Border.all()),
                child: _image != null
                    ? Image.file(
                        _image!.absolute,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  loading = true;
                });
                Reference reference = FirebaseStorage.instance.ref(
                    '/FolderImages${DateTime.now().millisecondsSinceEpoch}');
                UploadTask uploadTask = reference.putFile(_image!.absolute);
                Future.value(uploadTask).then((value) async {
                  var newUrl = await reference.getDownloadURL();
                  database
                      .child(DateTime.now().microsecondsSinceEpoch.toString())
                      .set({'id': 999, 'title': newUrl.toString()}).then(
                          (value) {
                    setState(() {
                      loading = false;
                    });
                    Utils.toatsMessage('Image Uploaded');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils.toatsMessage('Something went wrong');
                  });
                }).onError((error, stackTrace) {
                  Utils.toatsMessage(error.toString());
                });
              },
              child: Button(isLoading: loading, title: "Upload"))
        ],
      ),
    );
  }
}
