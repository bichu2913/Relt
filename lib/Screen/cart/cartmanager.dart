import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:relt/firebase/firebasedata.dart';

class CartManager {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseService firebaseService = FirebaseService();

 Future<void> toggleCartStatus(DocumentSnapshot<Object?> productSnapshot, bool isInCart) async {
  try {
    String? userId = user.email;
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;
        String productId = productSnapshot.id;

        int index = cart.indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          cart[index]['quantity'] += 1;
        } else {
          cart.add({'productId': productId, 'quantity': 1});
        }
      } else {
        List<Map<String, dynamic>> cart = [{'productId': productSnapshot.id, 'quantity': 1}];
        userData = {'cart': cart};
      }

      await usersCollection.doc(userId).set(userData, SetOptions(merge: true));
    }
  } catch (e) {
    print('Error toggling cart status: $e');
  }
}
Future<void> deleteItemFromCart(DocumentSnapshot<Object?> productSnapshot) async {
  try {
    String? userId = user.email;
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;
        String productId = productSnapshot.id;

        int index = cart.indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          cart.removeAt(index);
          await usersCollection.doc(userId).update({'cart': cart});

          // Product successfully removed from cart
          print('Product removed from cart');
        }
      }
    }
  } catch (e) {
    print('Error deleting item from cart: $e');
  }
}
Future<int> getQuantity(String productId) async {
    try {
      String? userId = user.email;
      DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('cart')) {
          List<dynamic> cart = userData['cart'] as List<dynamic>;

          int index = cart.indexWhere((item) => item['productId'] == productId);
          if (index != -1) {
            return cart[index]['quantity'] as int? ?? 0;
          }
        }
      }
    } catch (e) {
      print('Error getting quantity: $e');
    }

    return 0;
  }

Future<void> updateQuantity(String productId, int quantity) async {
  try {
    String? userId = user.email;
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        List<dynamic> updatedCart = cart.map((item) {
          if (item['productId'] == productId) {
            item['quantity'] = quantity;
          }
          return item;
        }).toList();

        await usersCollection.doc(userId).set({'cart': updatedCart}, SetOptions(merge: true));
      }
    }
  } catch (e) {
    print('Error updating quantity: $e');
  }
}





 Future<List<DocumentSnapshot>> getCartData() async {
  try {
    String? userId = user.email;

    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        print('Cart Length: ${cart.length}');

        List<DocumentSnapshot> products = await firebaseService.getProducts();

        print('All Products Length: ${products.length}');

        List<DocumentSnapshot> cartProducts = [];

        for (var cartItem in cart) {
          String productId = cartItem['productId'];
          
          for (var product in products) {
            if (productId == product.id) {
              cartProducts.add(product);
              break; // Break the inner loop if a match is found
            }
          }
        }

        print('Filtered Products Length: ${cartProducts.length}');

        return cartProducts;
      }
    }

    return [];
  } catch (e) {
    print('Error retrieving cart data: $e');
    return [];
  }
}

  
}

 