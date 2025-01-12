import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unichat_app/provider/cartProvider.dart';
import 'package:unichat_app/ui/pagrs/PayPage.dart';
import 'package:unichat_app/ui/pagrs/HomePage.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  late CartProvider _cartProvider;

  bool edit = false;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cartProvider.fetchCartProducts(); // جلب المنتجات عند فتح الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<CartProvider>(
            builder: (context, value, child) {
              return Column(
                children: [
                  // تصميم الشريط العلوي
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: EdgeInsets.all(7),
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 1, 33, 80),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 1, 33, 80),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Homepage()),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 150),
                                child: Text(
                                  "Trendy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color.fromARGB(255, 1, 33, 80),
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // قائمة المنتجات الموجودة في السلة
                  Expanded(
                    child: value.cartItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: value.cartItems.length,
                            itemBuilder: (context, index) {
                              var productData = value.cartItems[index].data()
                                  as Map<String, dynamic>;
                              String productId = value.cartItems[index].id;

                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: ListTile(
                                  leading: Image.network(
                                    productData['image_url'][0] ?? '',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    productData['title'] ?? 'title not found',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'price: ${productData['price']} \$',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  trailing: !edit
                                      ? Text(
                                          'quantity: ${productData['quantity']}')
                                      : IconButton(
                                          onPressed: () {
                                            value.removeFromCart(
                                                productId: productId,
                                                context: context);
                                          },
                                          icon: Icon(Icons.remove),
                                          color: Colors.red,
                                        ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text('The cart is empty'),
                          ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Paypage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 1, 33, 80),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.payment,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Pay Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
