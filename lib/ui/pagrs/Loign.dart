import 'package:awesome_dialog/awesome_dialog.dart'; // حزمة لعرض مربعات الحوار
import 'package:firebase_auth/firebase_auth.dart'; // مكتبة لتسجيل الدخول باستخدام Firebase
import 'package:flutter/material.dart'; // مكتبة تصميم واجهة Flutter
import 'package:unichat_app/ui/pagrs/HomePage.dart'; // صفحة الصفحة الرئيسية بعد تسجيل الدخول
import 'package:unichat_app/ui/pagrs/SignUp.dart'; // صفحة تسجيل الحساب الجديد
import 'package:unichat_app/utilites/sharedPref_helper.dart'; // أداة للتعامل مع التخزين المحلي

class Loign extends StatefulWidget {
  const Loign({super.key});

  @override
  State<Loign> createState() => _LoignState(); // إنشاء الحالة
}

class _LoignState extends State<Loign> {
  GlobalKey<FormState> FormStata = GlobalKey(); // مفتاح للتحقق من صحة النموذج

  TextEditingController emailController =
      TextEditingController(); // للتحكم بحقل البريد الإلكتروني
  TextEditingController passweordController =
      TextEditingController(); // للتحكم بحقل كلمة المرور

  Future logIn() async {
    // دالة تسجيل الدخول
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 5, 60, 142), // لون مؤشر التحميل
            ));
          });

      // تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passweordController.text);
      User? user = userCredential.user; // جلب معلومات المستخدم
      String? idToken = await user?.getIdToken(); // الحصول على التوكن
      await SharedPrefrenceHelper.setToken(
          token: idToken!); // تخزين التوكن محلياً

      if (user != null) {
        // التحقق من وجود المستخدم
        print('User data: ${user}');
        await SharedPrefrenceHelper.setToken(token: idToken!).then((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Homepage())); // الانتقال للصفحة الرئيسية
        });
      } else {
        print('No data available');
      }
    } on FirebaseAuthException catch (e) {
      // معالجة الأخطاء في تسجيل الدخول
      print('Error: $e');
      Navigator.pop(context); // إغلاق مؤشر التحميل
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error, // نوع الرسالة (خطأ)
        animType: AnimType.rightSlide, // حركة الرسالة
        title: 'Error',
        desc: e.message ?? 'An error occurred while logging in', // وصف الخطأ
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شريط التصحيح
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white, // لون الخلفية
          body: Container(
            width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
            padding: const EdgeInsets.symmetric(horizontal: 24), // مسافة أفقية
            child: SingleChildScrollView(
              // التمرير
              child: Column(
                children: [
                  const SizedBox(
                    height: 20, // مسافة علوية
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width, // عرض النص
                    child: const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // محاذاة النص لليسار
                      children: [
                        Text(
                          "Login to Your", // عنوان الشاشة
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w500, // سماكة النص
                          ),
                        ),
                        SizedBox(
                          height: 5, // مسافة بين الأسطر
                        ),
                        Text(
                          "Account", // النص التكميلي
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 60, 142), // لون النص
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20, // مسافة بين النص والنموذج
                  ),
                  Form(
                    key: FormStata, // مفتاح التحقق
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              emailController, // للتحكم بحقل البريد الإلكتروني
                          decoration: const InputDecoration(
                            labelText: "Email", // اسم الحقل
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25)), // حواف دائرية
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey), // لون الإطار عند التركيز
                            ),
                          ),
                          validator: (value) {
                            // التحقق من صحة الإدخال
                            if (value!.isEmpty) {
                              return "Field is empty"; // رسالة خطأ
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10, // مسافة بين الحقول
                          height: 12,
                        ),
                        TextFormField(
                          controller:
                              passweordController, // للتحكم بحقل كلمة المرور
                          decoration: const InputDecoration(
                            labelText: "Password", // اسم الحقل
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          validator: (value) {
                            // التحقق من صحة الإدخال
                            if (value!.isEmpty) {
                              return "Field is empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20, // مسافة بين الحقلين
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 5, 60, 142), // لون الزر
                            ),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.white), // لون النص
                            minimumSize: MaterialStateProperty.all(
                              const Size(300, 50), // حجم الزر
                            ),
                          ),
                          onPressed: () {
                            if (FormStata.currentState!.validate()) {
                              logIn(); // استدعاء دالة تسجيل الدخول
                            }
                          },
                          child: const Text("Login"), // نص الزر
                        ),
                      ],
                    ),
                  ),
                  Row(
                    // لإنشاء صف يحتوي على تسجيل حساب جديد
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const Signup(), // الانتقال لصفحة تسجيل الحساب
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
