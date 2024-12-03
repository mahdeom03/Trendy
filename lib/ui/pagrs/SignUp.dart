import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:unichat_app/ui/pagrs/HomePage.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart';
import 'package:unichat_app/utilites/sharedPref_helper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> FormStata = GlobalKey();

  Future signUp() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      User? user = userCredential.user;
      String? idToken = await user?.getIdToken();
      print('token is ${idToken}');
      await SharedPrefrenceHelper.setToken(token: idToken!);
      addUserDetails(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
      ).then((res) {
        // print('response is ${res.id}');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Homepage()));
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message,
      ).show();
      print('error is $e');
    }
  }

  Future addUserDetails({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': 'cs',
      'id': FirebaseAuth.instance.currentUser?.uid,
      'imageUrl': ''
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.translate))
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // margin: EdgeInsets.fromLTRB(9, 15, 29, 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create Your",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Account",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: FormStata,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 165,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("الحقل فارغ");
                                      }
                                    },
                                    controller: firstNameController,
                                    decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        labelText: "First Name",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                  )),
                              // SizedBox(
                              //   width: 4,
                              // ),
                              Container(
                                  width: 165,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "الحقل فارغ";
                                      }
                                    },
                                    controller: lastNameController,
                                    decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        labelText: "Last Name",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: 350,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الحقل فارغ";
                                  }
                                },
                                controller: emailController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: 350,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الحقل فارغ";
                                  }
                                },
                                controller: passwordController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: 350,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الحقل فارغ";
                                  }
                                },
                                controller: confirmPasswordController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    labelText: "Confirm Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            width: 300,
                            child: MaterialButton(
                              onPressed: () async {
                                if (FormStata.currentState!.validate()) {
                                  FormStata.currentState!.save();
                                  // print(emailController.text);
                                  // print(passwordController.text);
                                  signUp();
                                }
                              },
                              child: const Text('Sign up'),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Loign()));
                    },
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: 'Already have an account?  ',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: 'login', style: TextStyle(color: Colors.green))
                    ])),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
