import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<QueryDocumentSnapshot>? cartProducts = []; // قائمة المنتجات

  List<QueryDocumentSnapshot> get cartItems => cartProducts!;

  int get cartCount => cartProducts!.length;

  // كولكشن cart الخاص بالمستخدم الحالي
  CollectionReference cart = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('cart');

  // جلب المنتجات من السلة الخاصة بالمستخدم الحالي
  Future<void> fetchCartProducts() async {
    try {
      // احصل على المنتجات من السلة الخاصة بالمستخدم الحالي
      QuerySnapshot querySnapshot = await cart.get();
      cartProducts = querySnapshot.docs;
      notifyListeners();
      print('منتجات السلة للمستخدم الحالي: ${cartProducts}');
    } catch (e) {
      print('خطأ في جلب المنتجات من السلة: $e');
    }
  }

  // إضافة المنتج إلى السلة
  Future<void> addToCart(
      {required QueryDocumentSnapshot<Object?> product,
      required BuildContext context}) async {
    try {
      await cart.add(product.data() as Map<String, dynamic>);
      print('✅ تمت إضافة المنتج إلى السلة بنجاح!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تمت إضافة المنتج إلى السلة بنجاح!'),
        ),
      );
      notifyListeners();
    } catch (e) {
      print('❌ خطأ أثناء إضافة المنتج إلى السلة: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ أثناء إضافة المنتج إلى السلة: $e'),
        ),
      );
    }
  }

  // إزالة المنتج من السلة
  Future<void> removeFromCart(
      {required String productId, required BuildContext context}) async {
    try {
      final productDoc = cart.doc(productId);

      await productDoc.delete();
      print('✅ تمت إزالة المنتج من السلة بنجاح!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تمت إزالة المنتج من السلة بنجاح!'),
        ),
      );
      notifyListeners();
    } catch (e) {
      print('❌ خطأ أثناء إزالة المنتج من السلة: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ أثناء إزالة المنتج من السلة: $e'),
        ),
      );
    }
  }
}
