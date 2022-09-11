import 'dart:async';

import 'package:fire_learn/UI/auth/login.dart';
import 'package:fire_learn/UI/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

void isLogin(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user != null) {
    Timer(
        const Duration(seconds: 3),
        (() => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const PostScreen())))));
  } else {
    Timer(
        const Duration(seconds: 3),
        (() => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const LoginScreen())))));
  }
}
