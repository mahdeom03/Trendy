import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unichat_app/provider/cartProvider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'; // Importing the package
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firebase package

class Paypage extends StatefulWidget {
  @override
  _PaypageState createState() => _PaypageState();
}

class _PaypageState extends State<Paypage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'card'; // Default payment method is card

  // Function to process payment
  Future<void> _processPayment() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    try {
      // Get the cart items from the cartProvider
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final cartItems = cartProvider.cartItems;

      // Calculate total price
      double totalPrice = 0;
      for (var item in cartItems) {
        final product = item.data() as Map<String, dynamic>;
        double price = double.tryParse(product['price'].toString()) ?? 0.0;
        int quantity = int.tryParse(product['quantity'].toString()) ?? 1;
        totalPrice += price * quantity; // Multiply price by quantity
      }

      // Save data to Firebase
      await FirebaseFirestore.instance.collection('Pay').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'paymentMethod': _paymentMethod,
        'totalPrice': totalPrice,
        'cartItems': cartItems.map((item) => item.data()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message with a check icon
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Payment completed successfully!'),
            ],
          ),
        ),
      );
    } catch (e) {
      // In case of error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.cartItems;

        // Calculate total price
        double totalPrice = 0;
        for (var item in cartItems) {
          final product = item.data() as Map<String, dynamic>;
          double price = double.tryParse(product['price'].toString()) ?? 0.0;
          int quantity = int.tryParse(product['quantity'].toString()) ?? 1;
          totalPrice += price * quantity; // Multiply price by quantity
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Payment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 1, 33, 80),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white, // لون الأيقونات
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  cartItems.isEmpty
                      ? const Center(child: Text('No products in the cart'))
                      : Container(
                          height:
                              200, // Define a height or wrap it with a scrollable container
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final product = cartItems[index].data()
                                  as Map<String, dynamic>;
                              double price = double.tryParse(
                                      product['price'].toString()) ??
                                  0.0;
                              int quantity = int.tryParse(
                                      product['quantity'].toString()) ??
                                  1;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                      product['name'] ?? 'Name not available'),
                                  subtitle: Text('Quantity: $quantity'),
                                  trailing: Text('${price * quantity} JO.D'),
                                ),
                              );
                            },
                          ),
                        ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('$totalPrice JO.D',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment Method',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    items: const [
                      DropdownMenuItem(
                          value: 'card', child: Text('Credit Card')),
                      DropdownMenuItem(
                          value: 'cash', child: Text('Cash on Delivery')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select payment method',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Shipping Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Using InternationalPhoneNumberInput
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneController.text = number.phoneNumber!;
                    },
                    onInputValidated: (bool value) {
                      print(value
                          ? 'Phone number is valid'
                          : 'Phone number is invalid');
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
                  ElevatedButton(
                    onPressed: _processPayment,
                    child: const Text(
                      'Complete Payment',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 1, 33, 80),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
