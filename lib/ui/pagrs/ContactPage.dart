import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // Controllers لإدارة النصوص المدخلة
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _problemController = TextEditingController();

  // دالة لتقديم البيانات المدخلة إلى Firebase
  Future<void> _submitForm() async {
    String userName = _nameController.text;
    String userEmail = _emailController.text;
    String userPhone = _phoneController.text;
    String userProblem = _problemController.text;

    if (userName.isNotEmpty &&
        userEmail.isNotEmpty &&
        userPhone.isNotEmpty &&
        userProblem.isNotEmpty) {
      try {
        // إضافة البيانات إلى Firebase Firestore
        await FirebaseFirestore.instance.collection('contacts').add({
          'name': userName,
          'email': userEmail,
          'phone': userPhone,
          'problem': userProblem,
          'timestamp': FieldValue.serverTimestamp(), // تخزين التوقيت
        });

        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("سنتاوصل معك بأقرب وقت "),
        ));

        // مسح الحقول بعد الإرسال
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _problemController.clear();
      } catch (e) {
        // في حال حدوث خطأ
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("حدث خطأ: $e"),
        ));
      }
    } else {
      // إذا كانت الحقول فارغة
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("الرجاء ملء جميع الحقول"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 33, 80),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // لون الأيقونات
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            const Text(" Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _phoneController.text = number.phoneNumber!;
              },
              onInputValidated: (bool value) {
                print(value ? 'رقم الهاتف صالح' : 'رقم الهاتف غير صالح');
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              initialValue: PhoneNumber(isoCode: 'JO'),
              textFieldController: TextEditingController(),
              formatInput: false,
              keyboardType: TextInputType.phone,
              inputDecoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Problem",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _problemController,
              decoration: const InputDecoration(
                hintText: " Enter your problem",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 4, // السماح بكتابة نص طويل
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 1, 33, 80),
                ),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16)),
              ),
              child: const Text("Submit",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
