import 'package:flutter/material.dart';
import 'package:unichat_app/widget/Location_Service.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();

  // المتغيرات static حتى نتمكن من الوصول إليها من الصفحات الأخرى
  static String cityName = "";
  static String countryName = "";
}

class _LocationPageState extends State<LocationPage> {
  String _location = "Location not determined yet"; // لتخزين الموقع الجغرافي
  bool _isLoading = false; // لتحديد حالة التحميل

  @override
  void initState() {
    super.initState();
    // استدعاء الميثود الجلوبال للحصول على الموقع
    _getLocation();
  }

  // دالة للحصول على الموقع من الميثود الجلوبال
  void _getLocation() {
    setState(() {
      _isLoading = true; // تفعيل مؤشر التحميل
    });

    LocationService.getLocation((location, city, country) {
      // التحديث من الميثود الجلوبال
      setState(() {
        _location = location;
        LocationPage.cityName = city;
        LocationPage.countryName = country;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Geographical Location"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              Text("Your current location: $_location"), // عرض الموقع
            if (!_isLoading && LocationPage.cityName.isNotEmpty)
              Text("City: ${LocationPage.cityName}"), // عرض اسم المدينة
            if (!_isLoading && LocationPage.countryName.isNotEmpty)
              Text("Country: ${LocationPage.countryName}"), // عرض اسم البلد
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 5, 60, 142),
                ),
              ),
              onPressed: _getLocation,
              child: Text(
                'Get Location',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
