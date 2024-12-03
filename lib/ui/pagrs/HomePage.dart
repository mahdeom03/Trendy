import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart';
import 'package:unichat_app/ui/pagrs/Mypro.dart';
import 'package:unichat_app/ui/pagrs/profuctDetalis.dart';
import 'SignUp.dart';
import 'auth.dart';
import 'SecondPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<IconData> icons = [
    Icons.all_inbox,
    Icons.shop,
    Icons.card_travel,
    Icons.shopping_bag,
    Icons.ice_skating,
  ];

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

  @override
  void initState() {
    fetchProducts();
    functionsOfIcons = [
      () {
        // filter = images.where((d) => d['type'] == 'Shirt').toList();
        fetchProducts();
        setState(() {});
      },
      () {
        // filter = images.where((d) => d['type'] == 'Shirt').toList();
        fetchProducts(categorey: 'Shirt');
        setState(() {});
      },
      () {
        // filter = images.where((d) => d['type'] == 'Jeans').toList();
        fetchProducts(categorey: 'Jeans');
        setState(() {});
      },
      () {
        // filter = images.where((d) => d['type'] == 'Jackets').toList();
        fetchProducts(categorey: 'Jackets');
        setState(() {});
      },
      () {
        // filter = images.where((d) => d['type'] == 'Shoes').toList();
        fetchProducts(categorey: 'Shoes');
        setState(() {});
      },
    ];
    filter = images;
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  List<QueryDocumentSnapshot>? productList = [];
  Future<void> fetchProducts({String? categorey}) async {
    try {
      // Query Firestore for products with category 'Shirt'
      if (categorey != null) {
        QuerySnapshot querySnapshot =
            await products.where('category', isEqualTo: categorey).get();
        setState(() {
          // Assign the list of documents to productsData
          productList = querySnapshot.docs;
          log('data is ${productList}');
        });
      } else {
        QuerySnapshot querySnapshot = await products.get();
        setState(() {
          // Assign the list of documents to productsData
          productList = querySnapshot.docs;
          log('data is ${productList}');
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 1, 33, 80),
                                  )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 7),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your location',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text('Jordan, Amman',
                                  style: TextStyle(color: Colors.white)),
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
                    Text(
                      'See all',
                      style: TextStyle(
                          color: Color.fromARGB(255, 5, 60, 142),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
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
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    children: [
                      for (int i = 0; i < productList!.length; i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  products: productList![i],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                productList![i]['image_url'][0] != ''
                                    ? Image.network(
                                        productList![i]['image_url'][0],
                                        width: 140,
                                        height: 140,
                                      )
                                    : Icon(Icons.image),
                                const SizedBox(height: 10),
                                Text(productList![i]['title']!),
                                const SizedBox(height: 10),
                                Text(
                                  '${productList![i]['price']!} JOD',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(2, 3),
                                  )
                                ]),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("User Name"),
                accountEmail: Text("user@example.com"),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 1, 33, 80),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      AssetImage("images/3.pug.jpg"), // صوره تاعت MY PRO//
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("My Profile"),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyPro()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Loign()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
