import 'package:fire_learn/UI/auth/signup.dart';
import 'package:fire_learn/UI/post_screen.dart';
import 'package:fire_learn/utilis/toast_message.dart';
import 'package:fire_learn/utilis/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
        title: const Text('Login'),
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
                    .signInWithEmailAndPassword(
                        email: emailEditingController.text.toString(),
                        password: passwordEditingController.text.toString())
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
            child: Button(
              isLoading: isLoading,
              title: 'Login',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dont have an account? '),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUPScreen()));
                  },
                  child: const Text(
                    'SignUp Here',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
