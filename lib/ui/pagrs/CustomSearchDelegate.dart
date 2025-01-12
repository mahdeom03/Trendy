import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unichat_app/ui/pagrs/ProductDetails.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<QueryDocumentSnapshot> products;

  CustomSearchDelegate({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // مسح النص في خانة البحث
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // إغلاق نافذة البحث
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white, // تحديد خلفية بيضاء
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final product = results[index];
          return ListTile(
            title: Text(product['title']),
            subtitle: Text('${product['price']} JOD'),
            leading: Image.network(product['image_url'][0]),
            onTap: () {
              // يمكنك هنا إضافة منطق الانتقال إلى صفحة تفاصيل المنتج
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white, // تحديد خلفية بيضاء
      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final product = suggestions[index];
          return ListTile(
            title: Text(product['title']),
            subtitle: Text('${product['price']} JOD'),
            leading: Image.network(product['image_url'][0]),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailPage(products: (product))));
            },
          );
        },
      ),
    );
  }
}
