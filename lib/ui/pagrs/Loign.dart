import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unichat_app/ui/pagrs/HomePage.dart';
import 'package:unichat_app/ui/pagrs/SignUp.dart';
import 'package:unichat_app/utilites/sharedPref_helper.dart';

class Loign extends StatefulWidget {
  const Loign({super.key});

  @override
  State<Loign> createState() => _LoignState();
}

class _LoignState extends State<Loign> {
  GlobalKey<FormState> FormStata = GlobalKey();

  TextEditingController emailController =
      TextEditingController(); // تكست ايديت كنترولور
  TextEditingController passweordController = TextEditingController();

  //هاي كبسة الجوجل
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; //-----

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Homepage(),
      ),
    );
  }

  Future logIn() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.green,
            ));
          });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passweordController.text);
      User? user = userCredential.user;
      String? idToken = await user?.getIdToken();
      await SharedPrefrenceHelper.setToken(token: idToken!);
      if (user != null) {
        log('data is ${user}');
        await SharedPrefrenceHelper.setToken(token: idToken!).then((_) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Homepage()));
        });
      } else {
        print('no have data');
      }
    } on FirebaseAuthException catch (e) {
      print('er is $e');
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.translate,
                    ),
                  ],
                ),
                SizedBox(
                  width: 2,
                  height: 3,
                )
              ],
            ),
          ),
          body: Column(
            children: [
              const Text(
                "Login to Your",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 39,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "Account",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 39,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 32,
                width: 12,
              ),
              Column(
                children: [
                  Container(
                      width: 360,
                      child: Form(
                          key: FormStata,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الحقل فارغ";
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                                height: 12,
                              ),
                              Container(
                                  width: 360,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "الحقل فارغ";
                                      }
                                    },
                                    controller: passweordController,
                                    decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                        ),
                                        labelText: "Password",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(900)),
                                child: TextButton(
                                  autofocus: false,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(300, 50)),
                                  ),
                                  onPressed: () async {
                                    if (FormStata.currentState!.validate()) {
                                      FormStata.currentState!.save();
                                      print(emailController.text);
                                      print(passweordController.text);
                                      // try {
                                      //   final credential = await FirebaseAuth
                                      //       .instance
                                      //       .createUserWithEmailAndPassword(
                                      //     email: emailController.text,
                                      //     password: PassweordController.text,
                                      //   );
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               Homepage()));
                                      // } on FirebaseAuthException catch (e) {
                                      //   if (e.code == 'weak-password') {
                                      //     print(
                                      //         'The password provided is too weak.');
                                      //     AwesomeDialog(
                                      //       context: context,
                                      //       dialogType: DialogType.error,
                                      //       animType: AnimType.rightSlide,
                                      //       title: 'Error',
                                      //       desc:
                                      //           'The password provided is too weak.',
                                      //     ).show();
                                      //   } else if (e.code ==
                                      //       'email-already-in-use') {
                                      //     print(
                                      //         'The account already exists for that email.');
                                      // AwesomeDialog(
                                      //   context: context,
                                      //   dialogType: DialogType.error,
                                      //   animType: AnimType.rightSlide,
                                      //   title: 'Error',
                                      //   desc:
                                      //       'The account already exists for that email.',
                                      // ).show();
                                      //   }
                                      // } catch (e) {
                                      //   print(e);
                                      // }
                                      logIn();
                                    }
                                  },
                                  child: const Text("Loign"),
                                ),
                              ),
                            ],
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont have an account?"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            autofocus: false,
                            textColor: Colors.green,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Signup()));
                            },
                            child: const Text("Sing UP"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                width: 300,
                child: MaterialButton(
                  textColor: Colors.white,
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: const Text("Loing with Google"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
