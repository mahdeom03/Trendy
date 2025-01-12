import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:unichat_app/provider/cartProvider.dart';
import 'package:unichat_app/ui/pagrs/CartPage.dart';
import 'package:unichat_app/ui/pagrs/Change%20password.dart';
import 'package:unichat_app/ui/pagrs/CustomSearchDelegate.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart';
import 'package:unichat_app/ui/pagrs/Mypro.dart';
import 'package:unichat_app/ui/pagrs/ProductDetails.dart';
import 'package:unichat_app/ui/pagrs/ContactPage.dart';
import 'package:unichat_app/ui/pagrs/about.dart';
import 'package:unichat_app/widget/LocationPage.dart';
import 'package:unichat_app/widget/PromotionalBanner.dart';
import '../../widget/Location_Service.dart';
import 'SignUp.dart';
import 'auth.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _location = "Location not determined yet"; // لتخزين الموقع الجغرافي
  bool _isLoading = false; // لتحديد حالة التحميل
  String city = 'Null';
  List<IconData> icons = [
    Icons.all_inbox,
    Icons.shop,
    Icons.card_travel,
    Icons.shopping_bag,
    Icons.ice_skating,
  ];
  void _getLocation() {
    setState(() {
      _isLoading = true;
    });

    LocationService.getLocation((location, city, country) {
      print('Location: $location');
      print('City: $city');
      print('Country: $country');

      setState(() {
        _location = location;
        LocationPage.cityName = city; // تحديث المدينة
        LocationPage.countryName = country; // تحديث البلد
        _isLoading = false;
      });
    });
  }

  List<String> textOfIcons = ['All', 'T-shirt', 'Jeans', "Jackets", "Shoes"];

  List<Map<String, String>> images = [
    {"image": "images/2.png", "type": "Jeans", "price": "25 JOD"},
    {"image": "images/1.png", "type": "Shirt", "price": "20 JOD"},
    {"image": "images/2.png", "type": "Jeans", "price": "30 JOD"},
    {"image": "images/1.png", "type": "Shirt", "price": "15 JOD"},
    {"image": "images/2.png", "type": "Jeans", "price": "35 JOD"},
    {"image": "images/1.png", "type": "Shirt", "price": "18 JOD"},
  ];

  List<Map<String, String>> filter = [];

  List<VoidCallback> functionsOfIcons = [];
  late CartProvider _cartProvider;
  LocationPage location1 = LocationPage();
  void initState() {
    super.initState();
    // تحديث المدينة هنا بعد جلب الموقع
    city = LocationPage.cityName; // تأكد من تعيين المدينة
    fetchProducts();
    _getLocation();
    print(city);
    functionsOfIcons = [
      () {
        fetchProducts();
        setState(() {});
      },
      () {
        fetchProducts(categorey: 'Shirt');
        setState(() {});
      },
      () {
        fetchProducts(categorey: 'Jeans');
        setState(() {});
      },
      () {
        fetchProducts(categorey: 'Jackets');
        setState(() {});
      },
      () {
        fetchProducts(categorey: 'Shoes');
        setState(() {});
      },
    ];
    filter = images;
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cartProvider.fetchCartProducts();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  List<QueryDocumentSnapshot>? productList = [];

  Future<void> fetchProducts({String? categorey, String? searchQuery}) async {
    try {
      QuerySnapshot querySnapshot;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        querySnapshot = await products
            .where('title', isGreaterThanOrEqualTo: searchQuery)
            .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .get();
      } else if (categorey != null) {
        querySnapshot =
            await products.where('category', isEqualTo: categorey).get();
      } else {
        querySnapshot = await products.get();
      }

      setState(() {
        productList = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<CartProvider>(builder: (context, value, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(255)),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Cartpage()))
                .then((_) async => await value.fetchCartProducts());
          },
          backgroundColor: Color.fromARGB(255, 5, 60, 142),
          elevation: 4.0,
          tooltip: 'عرض سلة المشتريات',
          child: Stack(
            clipBehavior: Clip.none, // Allows the badge to overflow
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 30.0,
              ),
              if (value.cartCount >
                  0) // Only show the badge if there are items in the cart
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.red, // Badge color
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${value.cartCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 1, 33, 80),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'images/profile_image.jpg'), // ضع صورة الملف الشخصي هنا
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Trendy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.home, color: Color.fromARGB(255, 1, 33, 80)),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 1, 33, 80)),
                title: const Text(
                  'My Profile',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPro()),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.settings, color: Color.fromARGB(255, 1, 33, 80)),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LocationPage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline, // أيقونة تغيير كلمة المرور
                  color: Color.fromARGB(255, 1, 33, 80),
                ),
                title: const Text(
                  'ChangePasswor',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordWidget(), // تأكد أن ChangePasswordWidget معرف بشكل صحيح
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.contact_mail, // تغيير أيقونة لتناسب "اتصل بنا"
                  color: Color.fromARGB(255, 1, 33, 80),
                ),
                title: const Text(
                  "contact us",
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80), // نفس اللون للعنوان
                    fontSize: 18,
                    fontWeight: FontWeight.w500, // جعل الخط متوسط السماكة
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ContactPage(), // التأكد من أن اسم الصفحة هو ContactPage
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline, // أيقونة مناسبة لـ "من نحن"
                  color: Color.fromARGB(255, 1, 33, 80),
                ),
                title: const Text(
                  "about us", // النص باللغة العربية
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(), // صفحة من نحن
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.logout, color: Color.fromARGB(255, 1, 33, 80)),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 33, 80),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Loign()), // استبدال LoginPage إذا كان اسمك مختلف
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.sizeOf(context).width,
                  height: 112,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 33, 80),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Trendy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 1, 33, 80),
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              icon: Icon(Icons.search_rounded,
                                  color: Colors.white, size: 30),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(
                                      products: productList!),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your location',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                  "Location: ${LocationPage.cityName}, ${LocationPage.countryName}",
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                          color: Color.fromARGB(255, 5, 60, 142),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < icons.length; i++)
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey, blurRadius: 1.5),
                                ]),
                            child: IconButton(
                                onPressed: functionsOfIcons[i],
                                icon: Icon(icons[i], color: Colors.orange)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            textOfIcons[i],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 5, 60, 142),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                  ],
                ),
                const PromotionalBanner(), // إضافة البانر هنا
                const SizedBox(height: 20),

                Container(
                  height: MediaQuery.sizeOf(context).height,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: productList!.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                products: productList![i],
                              ),
                            ),
                          ).then((_) => _cartProvider.fetchCartProducts());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              productList![i]['image_url'][0] != ''
                                  ? Image.network(
                                      productList![i]['image_url'][0],
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image),
                              const SizedBox(height: 10),
                              Text(
                                productList![i]['title']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${productList![i]['price']} JOD',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }));
  }
}
