import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relt/firebase/firebasedata.dart';
import 'package:relt/view/address/adressdisplay.dart';
import 'package:relt/view/buy/confirmorder.dart';
import 'package:relt/view/buy/payment.dart';
import '../model/product.dart';
import '../view/address/address.dart';

class BuyController {
  final BuildContext context;
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // late User _user;
  late Product _product;
  late List<String> _sizes;
  int _quantity = 1;
  String _selectedSize = '';
  int _selectedAddressIndex = -1;
  int _stock = 0;
  bool _isFlagSet = false;
  bool _isFormValid = false;

  Product get product => _product;
  List<String> get sizes => _sizes;
  int get quantity => _quantity;
  String get selectedSize => _selectedSize;
  int get selectedAddressIndex => _selectedAddressIndex;
  int get stock => _stock;
  bool get isFlagSet => _isFlagSet;
  bool get isFormValid => _isFormValid;

    AddressList? get addresses => AddressList(
        userId: _auth.currentUser?.email as String,
        toggleFlagCallback: () {},
        onAddressSelected: (selectedAddressIndex) {
          _selectedAddressIndex = selectedAddressIndex;
          updateFormValidity();
        },
        selectedAddressIndex: _selectedAddressIndex,
      );

  

  BuyController(this.context ,DocumentSnapshot productSnapshot) {
    final Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;
    List<dynamic>? imageUrls = data?['images'] as List<dynamic>?;
    final String imageUrl = imageUrls != null && imageUrls.isNotEmpty
        ? imageUrls[0] as String? ?? ''
        : '';
    final String productName = data?['name'] as String? ?? '';
    final double productPrice = data?['price'] as double? ?? 0.0;
    final String productDescription = data?['description'] as String? ?? '';
    final int stock = data?['stock'] as int? ?? 0;

    _product = Product(
      imageUrl: imageUrl,
      productName: productName,
      productPrice: productPrice,
      productDescription: productDescription,
      stock: stock,
    );

    _sizes = ['S', 'M', 'L', 'XL'];
    _stock = stock;
   
  }

  void incrementQuantity(String productId, int currentQuantity, int stock) async {
  try {
    // Increment the quantity if stock is available
    if (currentQuantity < stock) {
      int newQuantity = currentQuantity + 1;

      // Update the quantity in the state
      _quantity = newQuantity;
      updateFormValidity();

      // Update the quantity in the Firestore database
      await updateQuantityInDatabase(productId, newQuantity);
    } else {
      // Show a snackbar indicating insufficient stock
     
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error incrementing quantity: $e');
  }
}

void decrementQuantity(String productId, int currentQuantity) async {
  try {
    // Decrement the quantity if it's greater than 1
    if (currentQuantity > 1) {
      int newQuantity = currentQuantity - 1;

      // Update the quantity in the state
      _quantity = newQuantity;
      updateFormValidity();

      // Update the quantity in the Firestore database
      await updateQuantityInDatabase(productId, newQuantity);
    }
  } catch (e) {
    print('Error decrementing quantity: $e');
  }
}

Future<void> updateQuantityInDatabase(String productId, int quantity) async {
  try {
    // Implement the logic to update the quantity in the database
    // You can use the FirebaseFirestore instance to access the database and update the corresponding document
    
    // Example code to update the quantity in Firestore
    String? userId = _auth.currentUser?.email;
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Get the current cart data
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
    Map<String, dynamic>? userData = userSnapshot.data();
    List<dynamic> cart = userData?['cart'] ?? [];

    // Find the product in the cart
    int index = cart.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      // Update the quantity
      cart[index]['quantity'] = quantity;

      // Update the cart data in Firestore
      await userRef.update({'cart': cart});
    }
  } catch (e) {
    print('Error updating quantity in the database: $e');
  }
}

   void navigateToAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAddressPage(),
      ),
    );
  }
   void navigateToPayment(BuildContext context, ) {
    
    double totalPrice = _product.productPrice * _quantity;
    
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
  
  
  Future<int> getProductQuantity(String productId) async { 
    try {
      String? userId = _auth.currentUser?.email;
      DocumentSnapshot<Object?> userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('cart')) {
          List<dynamic> cart = userData['cart'] as List<dynamic>;

          int index = cart
              .indexWhere((item) => item['productId'] == productId);
          if (index != -1) {
            return cart[index]['quantity'] as int? ?? 0;
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return 0;
  }

  
  

  void updateFormValidity() {
    _isFormValid = validateForm();
  }

  bool validateForm() {
    if (_selectedAddressIndex == -1) {
      return false; // No address selected
    }

    if (_selectedSize.isEmpty) {
      return false; // No size selected
    }

    if (_quantity < 1) {
      return false; // Quantity must be at least 1
    }

    return true;
  }

  void updateSelectedSize(String size) {
    _selectedSize = size;
    updateFormValidity();
    
  }

  void onAddressSelected(int selectedAddressIndex) {
    _selectedAddressIndex = selectedAddressIndex;
    updateFormValidity();
  }

  Future<Map<String, dynamic>?> getSelectedAddress() async {
    try {
      final String? userId = _auth.currentUser?.email;
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data();
        List<dynamic> addresses = userData?['addresses'] ?? [];

        if (addresses.isNotEmpty &&
            _selectedAddressIndex >= 0 &&
            _selectedAddressIndex < addresses.length) {
          Map<String, dynamic> selectedAddress = addresses[_selectedAddressIndex];
          return selectedAddress;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return null; // Return null if no address is selected or an error occurred
  }

  Future<void> placeOrder(DocumentSnapshot productSnapshot) async {
    // Retrieve the selected address
    Map<String, dynamic>? selectedAddress = await getSelectedAddress();

    if (selectedAddress != null) {
      try {
        // Create a new order document with the user's ID as the document name
        String? userId = _auth.currentUser?.email;
        DocumentReference<Map<String, dynamic>> orderDocRef =
            FirebaseFirestore.instance.collection('orders').doc(userId);

        // Get the product price from the product snapshot
        double productPrice = productSnapshot['price'] as double? ?? 0.0;

        // Get the existing order data from Firestore
        DocumentSnapshot<Map<String, dynamic>> orderSnapshot = await orderDocRef.get();
        Map<String, dynamic>? orderData = orderSnapshot.data();

        // Check if the order document already exists
        if (orderSnapshot.exists && orderData != null) {
          // Retrieve the existing products array or create a new one
          List<dynamic> products = orderData['products'] ?? [];

          // Create the new product entry
          Map<String, dynamic> newProduct = {
            'productId': productSnapshot.id,
            'selectedSize': _selectedSize,
            'quantity': _quantity,
            'total': productPrice * _quantity,
            'price': productPrice,
            'selectedAddress': selectedAddress,
            'status': 'Confirmed',
          };

          // Add the new product to the products array
          products.add(newProduct);

          // Update the products array in the order data
          orderData['products'] = products;

          // Update the order document in Firestore
          await orderDocRef.set(orderData);
        } else {
          // If the order document doesn't exist, create a new order with the current product
          Map<String, dynamic> orderData = {
            'products': [
              {
                'productId': productSnapshot.id,
                'selectedSize': _selectedSize,
                'quantity': _quantity,
                'total': productPrice * _quantity,
                'price': productPrice,
                'selectedAddress': selectedAddress,
                'status': 'Confirmed',
              }
            ],
          };

          // Save the order data to Firestore
          await orderDocRef.set(orderData);
        }

        _isFormValid = false;
        _isFlagSet = true;

        // Show the order confirmation page 
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderConfirmedPage(),
          ),
        ); 
      } catch (e) {
        print(e.toString());
      }
    }
  }
   void toggleFlag() {
    _isFlagSet = true;
  }

  void initialize(DocumentSnapshot<Object?> productSnapshot) {}
}
