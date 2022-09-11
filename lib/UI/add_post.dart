import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_learn/utilis/toast_message.dart';
import 'package:fire_learn/utilis/widgets/button.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController postController = TextEditingController();
  bool loading = false;
  bool isloading = false;

  //Here we created a table to store data named 'Post'

  final database = FirebaseDatabase.instance.ref('Post');

  // Here we are gonna create an collection i.e a table for firestore database

  final fireStore = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                  labelText: 'What' 's in your mind',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            InkWell(
                onTap: (() {
                  setState(() {
                    loading = true;
                  });
                  //Here Database.Child means we create a chid for table named Post
                  //It sould be different for every post
                  //For that purpose we would use datetime function

                  // We also can create subchild of the child for that purpose we would do like this
                  // database.child(DateTime.now().millisecond.toString()).child('comments')
                  final String id =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  database.child(id).set({
                    'id': id,
                    'title': postController.text.toString()
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils.flushBarSnakError('Post Added', context);
                  }).onError((error, stackTrace) {
                    Utils.flushBarSnakError(error.toString(), context);
                  });
                }),
                child:
                    Button(isLoading: loading, title: 'Add Post in Realtime')),
            const SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: (() {
                  setState(() {
                    isloading = true;
                  });
                  //Here Database.Child means we create a chid for table named Post
                  //It sould be different for every post
                  //For that purpose we would use datetime function

                  // We also can create subchild of the child for that purpose we would do like this
                  // database.child(DateTime.now().millisecond.toString()).child('comments')
                  final String id =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      isloading = false;
                    });
                    Utils.flushBarSnakError('Post Added', context);
                  }).onError((error, stackTrace) {
                    setState(() {
                      isloading = false;
                    });
                    Utils.flushBarSnakError(error.toString(), context);
                  });
                }),
                child: Button(
                    isLoading: isloading, title: 'Add Post in Firestore'))
          ],
        ),
      ),
    );
  }
}
