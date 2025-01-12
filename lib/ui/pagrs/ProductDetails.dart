import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // استيراد مكتبة السلايدر
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:unichat_app/provider/cartProvider.dart'; // استيراد مكتبة مصادقة Firebase
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // مكتبة تقييم النجوم

class ProductDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> products;

  const ProductDetailPage({Key? key, required this.products}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = ''; // لتخزين المقاس المحدد
  double userRating = 0; // تقييم المستخدم الحالي
  List<double> ratings = []; // قائمة لتخزين التقييمات

  @override
  void initState() {
    super.initState();
    _fetchRatings(); // جلب التقييمات من Firebase
  }

  // 🟢 جلب التقييمات من Firebase
  Future<void> _fetchRatings() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('product_id', isEqualTo: widget.products.id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          ratings =
              snapshot.docs.map((doc) => doc['rating'] as double).toList();
        });
      }
    } catch (e) {
      print('خطأ في جلب التقييمات: $e');
    }
  }

  // 🟢 إرسال التقييم إلى Firebase
  Future<void> _submitRating(double rating) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('ratings').add({
          'product_id': widget.products.id,
          'user_id': userId,
          'rating': rating,
        });
        setState(() {
          userRating = rating; // حفظ التقييم الذي أرسله المستخدم
          ratings.add(rating); // إضافة التقييم الجديد إلى القائمة
        });
        print('تم إرسال التقييم بنجاح: $rating');
      } else {
        print('يجب تسجيل الدخول لتقييم المنتج');
      }
    } catch (e) {
      print('خطأ في إرسال التقييم: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL']; // قائمة المقاسات
    double averageRating = ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0; // حساب متوسط التقييم

    List<String> productImages =
        List<String>.from(widget.products['image_url'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Trendy',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 33, 80),
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 👇👇👇 سلايدر الصور 👇👇👇
                  productImages.isNotEmpty
                      ? CarouselSlider(
                          options: CarouselOptions(
                            height: 300, // ارتفاع السلايدر
                            autoPlay: true, // التشغيل التلقائي
                            enlargeCenterPage: true, // تكبير الصورة في المركز
                            aspectRatio: 16 / 9, // نسبة العرض إلى الارتفاع
                            viewportFraction: 0.8, // نسبة العرض لكل صورة
                          ),
                          items: productImages.asMap().entries.map((entry) {
                            int index = entry.key; // رقم الصورة (0, 1, 2, ...)
                            String imageUrl = entry.value; // رابط الصورة
                            return Builder(
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    // 👇 صورة المنتج 👇
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),

                                    // 👇 الرقم الذي يظهر أعلى الصورة 👇
                                    Positioned(
                                      top: 10, // المسافة من الأعلى
                                      right: 10, // المسافة من اليمين
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(
                                              0.6), // خلفية شفافة سوداء
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '#${index + 1}', // الرقم التسلسلي (يبدأ من 1)
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        )
                      : const Center(child: Text('لا توجد صور متاحة')),

                  const SizedBox(height: 20),

                  // 👇👇👇 عرض تقييم المنتج 👇👇👇
                  Text(
                    'Product Rating: ${averageRating.toStringAsFixed(1)} / 5',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 60, 142),
                    ),
                  ),

                  const SizedBox(height: 10),

                  RatingBar.builder(
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _submitRating(rating); // إرسال التقييم إلى Firebase
                    },
                  ),

                  const SizedBox(height: 20),

                  // 👇👇👇 معلومات المنتج 👇👇👇
                  Text(
                    '${widget.products['price']} JOD',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 33, 80),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    widget.products['description'] ?? 'لا يوجد وصف للمنتج',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 10,
                    children: sizes.map((size) {
                      return ChoiceChip(
                        label: Text(size),
                        selected: selectedSize == size,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedSize = selected ? size : '';
                          });
                        },
                        selectedColor: const Color.fromARGB(255, 1, 33, 80),
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: selectedSize == size
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 1, 33, 80),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      value.addToCart(
                          product: widget.products, context: context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
