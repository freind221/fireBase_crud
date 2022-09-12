import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_learn/UI/add_post.dart';
import 'package:fire_learn/UI/auth/login.dart';
import 'package:fire_learn/utilis/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;

  //To fetch data from the firebase database, we would create an instance of database
  //As we created an istance to add data in the database table
  //For that we do this

  final refer = FirebaseDatabase.instance.ref('Post');
  final search = TextEditingController();
  final edit = TextEditingController();

  // To fetch data from firestore, we would create query snapshot of the data

  final fireStoreData =
      FirebaseFirestore.instance.collection('posts').snapshots();
  CollectionReference reference =
      FirebaseFirestore.instance.collection('posts');

  @override
  void dispose() {
    search.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          actions: [
            IconButton(
                onPressed: (() {
                  auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const LoginScreen())));
                  }).onError((error, stackTrace) {
                    debugPrint(error.toString());
                  });
                }),
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: search,
                decoration: const InputDecoration(
                    hintText: "Search", border: OutlineInputBorder()),

                // Here we used onChanged property and used setstate in it
                // That means whenever the vaur of textformfield changes
                // Widget tree get rebuild

                onChanged: ((value) {
                  setState(() {});
                }),
              ),
            ),
            Expanded(

                //Here we have a widget that comes with firebase database
                //We would simply use it to display data on the screen

                child: FirebaseAnimatedList(
                    defaultChild:
                        const Center(child: CircularProgressIndicator()),
                    query: refer,
                    itemBuilder: ((context, snapshot, animation, index) {
                      final title = snapshot.child('title').value.toString();
                      if (search.text.isEmpty) {
                        return ListTile(
                          leading: SizedBox(
                              width: 270,
                              child: SingleChildScrollView(
                                child: Text(
                                    snapshot.child('title').value.toString()),
                              )),
                          trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: ((context) => [
                                    PopupMenuItem(
                                        child: ListTile(
                                      onTap: (() {
                                        Navigator.pop(context);
                                        // Here we have tp pass title and id of that title to out dunction
                                        // We got the ID by firebaseAnimated list
                                        showMyDialogue(
                                            title,
                                            snapshot
                                                .child('id')
                                                .value
                                                .toString());
                                      }),
                                      title: const Text('Edit'),
                                      leading: const Icon(Icons.edit),
                                    )),
                                    PopupMenuItem(
                                        child: ListTile(
                                      onTap: (() {
                                        Navigator.pop(context);

                                        // Here we used the ID to delete message from databse

                                        refer
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove()
                                            .then((value) {
                                          Utils.toatsMessage(
                                              'Deleted Succefully');
                                        }).onError((error, stackTrace) {
                                          Utils.toatsMessage(error.toString());
                                        });
                                      }),
                                      title: const Text('delete'),
                                      leading: const Icon(Icons.delete),
                                    ))
                                  ])),
                        );
                      } else if (title
                          .toLowerCase()
                          .contains(search.text.toLowerCase().toString())) {
                        return ListTile(
                            leading:
                                Text(snapshot.child('title').value.toString()));
                      } else {
                        return Container();
                      }
                    }))),

            //There is an another way of fetching data
            //That is using StreamBuilder
            //In this builder we have to provide stream to it that in our case would be our
            //Instance of firebase database

            // Expanded(
            //     child: StreamBuilder(
            //         stream: refer.onValue,
            //         builder: ((context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //           if (!snapshot.hasData) {
            //             return const Center(child: CircularProgressIndicator());
            //           } else {
            //             Map<dynamic, dynamic> map =
            //                 snapshot.data!.snapshot.value as dynamic;
            //             List<dynamic> posts = [];
            //             posts.clear();
            //             posts = map.values.toList();
            //             return ListView.builder(
            //                 itemCount: snapshot.data!.snapshot.children.length,
            //                 itemBuilder: ((context, index) {
            //                   return ListTile(
            //                     title: Text(posts[index]['title']),
            //                   );
            //                 }));
            //           }
            //         })))

            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: fireStoreData,
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final String title = snapshot
                                  .data!.docs[index]['title']
                                  .toString();
                              return ListTile(
                                title: Text(snapshot.data!.docs[index]['title']
                                    .toString()),
                                trailing: PopupMenuButton(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: ((context) => [
                                          PopupMenuItem(
                                              child: ListTile(
                                            onTap: (() {
                                              Navigator.pop(context);
                                              // Here we have tp pass title and id of that title to out dunction
                                              // We got the ID by firebaseAnimated list
                                              showMyDialogue(
                                                  title,
                                                  snapshot.data!.docs[index].id
                                                      .toString());
                                            }),
                                            title: const Text('Edit'),
                                            leading: const Icon(Icons.edit),
                                          )),
                                          PopupMenuItem(
                                              child: ListTile(
                                            onTap: (() {
                                              Navigator.pop(context);

                                              // Here we used the ID to delete message from databse

                                              reference
                                                  .doc(snapshot
                                                      .data!.docs[index].id
                                                      .toString())
                                                  .delete()
                                                  .then((value) {
                                                Utils.toatsMessage(
                                                    'Deleted Succefully');
                                              }).onError((error, stackTrace) {
                                                Utils.toatsMessage(
                                                    error.toString());
                                              });
                                            }),
                                            title: const Text('delete'),
                                            leading: const Icon(Icons.delete),
                                          ))
                                        ])),
                              );
                            }));
                      }
                    })))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const AddPostScreen())));
          }),
          child: const Icon(Icons.add),
        ));
  }

  Future<void> showMyDialogue(String title, String id) async {
    edit.text = title;
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextFormField(
              controller: edit,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // To update data we are gonna use the ID of that message
                    // For that we would use instance of the database we created
                    // And would give id as a path to it

                    refer
                        .child(id)
                        .update({'title': edit.text.toString()}).then((value) {
                      Utils.toatsMessage('Updated');
                    }).onError((error, stackTrace) {
                      Utils.flushBarSnakError(error.toString(), context);
                    });

                    // This is for firestore databse
                    reference.doc(id).update({
                      'title': edit.text.toString(),
                    }).then((value) {
                      Utils.toatsMessage("Updated");
                    }).onError((error, stackTrace) {
                      Utils.toatsMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        }));
  }
}
