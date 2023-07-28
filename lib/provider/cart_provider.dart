// import 'package:flutter/material.dart';
// import 'package:relt/controller/cart_page.dart';
// import 'package:relt/model/cart_page.dart';


// class CartProvider extends ChangeNotifier {
//   final CartController _cartController = CartController();
//   CartModel _cartModel = CartModel.empty();

//   CartModel get cartModel => _cartModel;

//   Future<void> initializeCartData() async {
//     await _cartController.initializeCartData();
//     _cartModel = _cartController.cartModel;
//     notifyListeners();
//   }

//   Future<void> updateQuantityInDatabase(String productId, int quantity) async {
//     await _cartController.updateQuantityInDatabase(productId, quantity);
//     await initializeCartData();
//   }

//   Future<void> deleteProductFromCart( productSnapshot) async {
//     await _cartController.deleteProductFromCart(productSnapshot);
//     await initializeCartData();
//   }
// }


 
