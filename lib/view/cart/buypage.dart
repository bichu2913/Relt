import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relt/view/address/address.dart';
import 'package:relt/view/buy/payment.dart';
import 'package:relt/firebase/firebasedata.dart';

import '../address/adressdisplay.dart';
import '../buy/confirmorder.dart';

class BuyPage extends StatefulWidget {
  final List<DocumentSnapshot> selectedProducts;
  final List<int> quantities;
  final double totalPrice;

  const BuyPage({
    Key? key,
    required this.selectedProducts,
    required this.quantities,
    required this.totalPrice,
  }) : super(key: key);

  @override
  BuyPageState createState() => BuyPageState();
}

class BuyPageState extends State<BuyPage> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> selectedSizes = [];
  int selectedAddressIndex = -1;
  AddressList? addresses;
  bool isFlagSet = false;
  bool isFormValid = false;
  int stock = 0;
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    selectedSizes = List<String>.filled(widget.selectedProducts.length, 'S');
  }
  

  void navigateToAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAddressPage(),
      ),
    );
  }
  void updateFormValidity() {
    setState(() {
      isFormValid = validateForm();
    });
  }
  bool validateForm() {
    if (selectedAddressIndex == -1) {
      return false; // No address selected
    }

    if (selectedSizes.isEmpty) {
      return false; // No size selected
    }

  

    return true;
  }
  Future<void> fetchStock( productId) async {
    try {
      // Fetch the stock from Firestore or any other data source
      DocumentSnapshot<Object?> productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        Map<String, dynamic>? productData =
            productSnapshot.data() as Map<String, dynamic>?;
        stock = productData?['stock'] as int? ?? 0;
      }
    } catch (e) {
      print(e.toString());
    }
  }
  void navigateToPayment() {
    double totalPrice = widget.totalPrice;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(
          totalPrice: totalPrice,
          toggleFlagCallback: toggleFlag,
        ),
      ),
    );
  }
  void toggleFlag() { 
    setState(() {
      isFlagSet = true;
    });
  }  
  void placeOrder() async {
  // Retrieve the selected address
  Map<String, dynamic>? selectedAddress = await getSelectedAddress();

  if (selectedAddress != null) {
    try {
      // Create a new order document with the user's ID as the document name
      String? userId = user.email;
      DocumentReference<Map<String, dynamic>> orderDocRef =
          FirebaseFirestore.instance.collection('orders').doc(userId);

      // Get the existing order data from Firestore
      DocumentSnapshot<Map<String, dynamic>> orderSnapshot = await orderDocRef.get();
      Map<String, dynamic>? orderData = orderSnapshot.data();

      // Check if the order document already exists
      if (orderSnapshot.exists && orderData != null) {
        // Retrieve the existing products array or create a new one
        List<dynamic> products = orderData['products'] ?? [];

        // Loop through the selected products
        for (int i = 0; i < widget.selectedProducts.length; i++) {
          DocumentSnapshot productSnapshot = widget.selectedProducts[i];
          Map<String, dynamic>? data =
              productSnapshot.data() as Map<String, dynamic>?;
          
          if (data == null) {
            continue;
          }
          fetchStock(productSnapshot.id);
          int newStatus = stock - widget.quantities[i];
          firebaseService.updateProduct(productSnapshot.id, newStatus);
          String productId = productSnapshot.id;
          String selectedSize = selectedSizes[i];
          int quantity = widget.quantities[i];
          double productPrice = (data['price'] as num?)?.toDouble() ?? 0.0;

          // Create the new product entry
          Map<String, dynamic> newProduct = {
            'productId': productId,
            'selectedSize': selectedSize,
            'quantity': quantity,
            'total': productPrice * quantity,
            'price': productPrice,
            'selectedAddress': selectedAddress,
            'status': 'Confirmed',
          };

          // Add the new product to the products array
          products.add(newProduct);
        }

        // Update the products array in the order data
        orderData['products'] = products;

        // Update the order document in Firestore
        await orderDocRef.set(orderData);
      } else {
        // If the order document doesn't exist, create a new order with the selected products
        List<Map<String, dynamic>> products = [];

        // Loop through the selected products
        for (int i = 0; i < widget.selectedProducts.length; i++) {
          DocumentSnapshot productSnapshot = widget.selectedProducts[i];
          Map<String, dynamic>? data =
              productSnapshot.data() as Map<String, dynamic>?;

          if (data == null) {
            continue;
          }

          String productId = productSnapshot.id;
          String selectedSize = selectedSizes[i];
          int quantity = widget.quantities[i];
          double productPrice = (data['price'] as num?)?.toDouble() ?? 0.0;

          // Create the new product entry
          Map<String, dynamic> newProduct = {
            'productId': productId,
            'selectedSize': selectedSize,
            'quantity': quantity,
            'total': productPrice * quantity,
            'price': productPrice,
            'selectedAddress': selectedAddress,
            'status': 'Confirmed',
          };

          // Add the new product to the products list
          products.add(newProduct);
        }

        // Create the order data with the products list
        Map<String, dynamic> orderData = {'products': products};

        // Save the order data to Firestore
        await orderDocRef.set(orderData);
      }
          try { 
      String? userId = user.email; 
     await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'cart': FieldValue.delete(),
  });

  // Cart products successfully deleted
  print('Cart products deleted');
} catch (e) {
  print('Error deleting cart products: $e');
}
      
      
      // Navigate to the order confirmation page
      // ignore: use_build_context_synchronously
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const OrderConfirmedPage(),
        ),
      );

      // Reset the form validation status
      setState(() {
        isFormValid = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}


  Future<Map<String, dynamic>?> getSelectedAddress() async {
    try {
      String? userId = user.email;
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data();
        List<dynamic> addresses = userData?['addresses'] ?? [];

        if (addresses.isNotEmpty &&
            selectedAddressIndex >= 0 &&
            selectedAddressIndex < addresses.length) {
          Map<String, dynamic> selectedAddress = addresses[selectedAddressIndex];
          return selectedAddress;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    addresses = AddressList(
      userId: user.email as String,
      toggleFlagCallback: () {},
      onAddressSelected: (selectedAddressIndex) {
        setState(() {
          this.selectedAddressIndex = selectedAddressIndex;
        });
      },
      selectedAddressIndex: selectedAddressIndex,
    );

    return Scaffold(
      appBar:  AppBar(title: const Text("BUY",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
        
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedProducts.length,
              itemBuilder: (context, index) {
                DocumentSnapshot productSnapshot = widget.selectedProducts[index];
                Map<String, dynamic>? data =
                    productSnapshot.data() as Map<String, dynamic>?;

                if (data == null) {
                  return const SizedBox();
                }

                String name = data['name'] as String? ?? '';
                double price = (data['price'] as num?)?.toDouble() ?? 0.0;
                List<dynamic>? imageUrls = data['images'] as List<dynamic>?;

                String imageUrl =
                    imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

                int quantity = widget.quantities[index];
                String size = selectedSizes[index];

                return ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: $quantity'),
                      DropdownButton<String>(
                        value: size,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSizes[index] = newValue!;
                          });
                        },
                        items: ['S', 'M', 'L', 'XL'].map((size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text(size),
                          );
                        }).toList(),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Price: ₹ ${price.toStringAsFixed(2)}'),
                          Text('Total Price: ₹ ${(price * quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Select an address:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                addresses != null
                    ? addresses!
                    : const Text(
                        'No addresses found.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    ElevatedButton( 
                       style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                      onPressed: () {
                        navigateToAddress();
                      }, 
                      child: const Text('Add Address'),
                    ),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                        onPressed: () {
                          navigateToPayment();
                        },
                        child: const Text('Add Payment'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                  onPressed: () { 
                    placeOrder();
                  },
                  child: const Text('Place Order'),
                ),
              ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text(
                    'Total Price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '₹ ${widget.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
