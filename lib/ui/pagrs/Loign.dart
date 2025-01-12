import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passweordController = TextEditingController();

  Future logIn() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 5, 60, 142),
            ));
          });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passweordController.text);
      User? user = userCredential.user;
      String? idToken = await user?.getIdToken();
      await SharedPrefrenceHelper.setToken(token: idToken!);
      if (user != null) {
        print('User data: ${user}');
        await SharedPrefrenceHelper.setToken(token: idToken!).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Homepage()));
        });
      } else {
        print('No data available');
      }
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: e.message ?? 'An error occurred while logging in',
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        Text(
                          "Login to Your",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 60, 142),
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
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is empty";
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10,
                          height: 12,
                        ),
                        TextFormField(
                          controller: passweordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 5, 60, 142),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            minimumSize: MaterialStateProperty.all(
                              const Size(300, 50),
                            ),
                          ),
                          onPressed: () {
                            if (FormStata.currentState!.validate()) {
                              logIn();
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Signup(),
                          ));
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
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
