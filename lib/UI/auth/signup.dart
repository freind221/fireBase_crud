import 'package:fire_learn/UI/auth/login.dart';
import 'package:fire_learn/UI/post_screen.dart';
import 'package:fire_learn/utilis/toast_message.dart';
import 'package:fire_learn/utilis/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SignUp'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailEditingController,
                    decoration: InputDecoration(
                        labelText: "EMAIL",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return "Email is not Valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "PASSWORD",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password field cannot be blank';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                if (formKey.currentState!.validate()) {
                  auth
                      .createUserWithEmailAndPassword(
                          email: emailEditingController.text,
                          password: passwordEditingController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const PostScreen())));
                    setState(() {
                      isLoading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils.flushBarSnakError(error.toString(), context);
                  });
                }
              },
              child: Button(isLoading: isLoading, title: 'SignUP')),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? '),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    'Login Here',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
