import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  Map<String, dynamic> products;

  OrderModel({
    required this.orderId,
    required this.products,
  });

  // Factory method to create an OrderModel instance from a Firestore document
  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document) {
    Map<String, dynamic>? data = document.data();
    Map<String, dynamic> productsData = Map<String, dynamic>.from(data?['products'] ?? {});

    return OrderModel(
      orderId: document.id,
      products: productsData,
    );
  }

  // You can add any additional methods and business logic here if needed
}


