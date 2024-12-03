import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPro extends StatefulWidget {
  const MyPro({super.key});

  @override
  State<MyPro> createState() => _MyProState();
}

class _MyProState extends State<MyPro> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _imageFile; // لتخزين الصورة المختارة

  final ImagePicker _picker = ImagePicker();

  // ميثود لاختيار الصورة من الكاميرا أو المعرض
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // ميثود لحذف الصورة
  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    // الصورة الشخصية
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage("images/3.pug.jpg")
                              as ImageProvider,
                    ),
                    // أيقونة الكاميرا أو تعديل الصورة
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 1, 33, 80),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // زر حذف الصورة
                    if (_imageFile != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _clearImage,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                // باقي المحتوى هنا (مثل الحقول أو الأزرار)
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      labelText: "First Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      labelText: "last Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      labelText: "email ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(height: 15),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      // أضف الوظيفة التي تريد تنفيذها عند النقر على الزر
                      print("SAVE button pressed!");
                    },
                    color:
                        const Color.fromARGB(255, 1, 33, 80), // لون خلفية الزر
                    elevation: 5, // الظل تحت الزر
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // لتعديل ارتفاع الزر
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // جعل الزر مستدير بالكامل
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        color: Colors.white, // لون النص
                        fontSize: 16, // حجم النص
                        fontWeight: FontWeight.bold, // جعل النص عريضًا
                        letterSpacing: 1.5, // زيادة التباعد بين الأحرف
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
