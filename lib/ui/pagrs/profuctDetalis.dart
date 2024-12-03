import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL']; // قائمة المقاسات
    double averageRating = ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0; // حساب متوسط التقييم

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trendy',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 33, 80),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.products['image_url'][0] != ''
                      ? Image.network(
                          widget.products['image_url'][0],
                          fit: BoxFit.cover,
                        )
                      : Center(child: Text('No image')),
                ),
              ),
              const SizedBox(height: 20),
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
                // "This product is made with high-quality materials to ensure durability and comfort. It's perfect for casual wear and adds a trendy touch to your outfit.",
                widget.products['description'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   "Select Size",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Color.fromARGB(255, 1, 33, 80),
              //   ),
              // ),
              const SizedBox(height: 10),
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
                      color: selectedSize == size ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                "Rate this product",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 33, 80),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        userRating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < userRating
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: Colors.orange,
                      size: 30,
                    ),
                  );
                }),
              ),
              if (ratings.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  "Average Rating: ${averageRating.toStringAsFixed(1)} ⭐",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (userRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please provide a rating."),
                      ),
                    );
                  } else {
                    setState(() {
                      ratings.add(userRating); // إضافة التقييم الجديد
                      userRating = 0; // إعادة التقييم الخاص بالمستخدم للصفر
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Thank you for your rating!"),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Submit Rating',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 33, 80),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity, // لضبط العرض على حجم الشاشة بالكامل
                padding: const EdgeInsets.symmetric(
                    vertical: 10), // إضافة padding داخلي
                decoration: BoxDecoration(
                  color: Colors.orange, // لون الخلفية
                  borderRadius: BorderRadius.circular(10), // زوايا دائرية
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // ظل خفيف
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // اتجاه الظل
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // المحاذاة في الوسط
                  children: [
                    Icon(
                      Icons.shopping_cart, // أيقونة السلة
                      color: Colors.white, // لون الأيقونة
                    ),
                    const SizedBox(width: 10), // مسافة بين الأيقونة والنص
                    GestureDetector(
                      onTap: () {
                        // إضافة الوظيفة هنا
                        print("add to cart pressed!");
                      },
                      child: Text(
                        "add to Cart",
                        style: TextStyle(
                          color: Colors.white, // لون النص
                          fontSize: 18, // حجم النص
                          fontWeight: FontWeight.bold, // جعل النص عريضًا
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
