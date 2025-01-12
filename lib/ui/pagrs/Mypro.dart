import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyPro extends StatefulWidget {
  const MyPro({super.key});

  @override
  State<MyPro> createState() => _MyProState();
}

class _MyProState extends State<MyPro> {
  final String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dyck9rsti/image/upload';
  final String apiKey = '596424129464446'; // Use your actual API key
  final String apiSecret =
      'V3LIBcE351fQ768m1WXNDup7oWM'; // Use your actual API secret
  final String uploadPreset = 'profile';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _imageFile;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();

  // Get user data from Firestore
  Future<void> getUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          setState(() {
            firstNameController.text = userDoc['firstName'] ?? '';
            lastNameController.text = userDoc['lastName'] ?? '';
            emailController.text = userDoc['email'] ?? '';
            imageUrl = userDoc['imageUrl'] ?? '';
          });
        }
      }
    } catch (e) {
      print('❌ Error getting user data: $e');
    }
  }

  Future<void> updateUserFirestore(
      {String? firstName,
      String? lastName,
      String? email,
      String? imageUrl}) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 1, 33, 80),
            ));
          });
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);

        Map<String, dynamic> updatedData = {};
        if (firstName != null) updatedData['firstName'] = firstName;
        if (lastName != null) updatedData['lastName'] = lastName;
        if (email != null) updatedData['email'] = email;
        if (imageUrl != null) updatedData['imageUrl'] = imageUrl;

        await userDoc.update(updatedData);
        Navigator.pop(context);
        print('User data updated in Firestore');
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 1, 33, 80),
            ));
          });
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files
          .add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var data = jsonDecode(responseData.body);
        var imageUrlCloud = data['secure_url'];
        imageUrl = imageUrlCloud;
        Navigator.pop(context);
        print('Image uploaded successfully: $imageUrlCloud');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully!')));
      } else {
        print('Upload failed: ${responseData.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image.')));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile image with camera icon
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            imageUrl != null && imageUrl!.isNotEmpty
                                ? NetworkImage(imageUrl!)
                                : _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : const AssetImage("images/3.pug.jpg")
                                        as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
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
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 5, 60, 142),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  onPressed: () {
                    updateUserFirestore(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      imageUrl: imageUrl,
                    );
                  },
                  color: Color.fromARGB(255, 1, 33, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
