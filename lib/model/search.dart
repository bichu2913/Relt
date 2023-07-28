// search.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchModel {
  late List<DocumentSnapshot> allProducts;
  late List<DocumentSnapshot> filteredProducts;

  final StreamController<List<DocumentSnapshot<Object?>>> _productsController =
      StreamController<List<DocumentSnapshot<Object?>>>();

  Stream<List<DocumentSnapshot<Object?>>> get productsStream => _productsController.stream;

  SearchModel() { 
    allProducts = [];
    filteredProducts = [];
    _productsController.add(filteredProducts); // Notify listeners about the initial data
  }

  Future<void> fetchProducts() async {
    QuerySnapshot menSnapshot = await FirebaseFirestore.instance.collection('men').get();
    QuerySnapshot womenSnapshot = await FirebaseFirestore.instance.collection('women').get();

    List<DocumentSnapshot> menDocs = menSnapshot.docs;
    List<DocumentSnapshot> womenDocs = womenSnapshot.docs;

    allProducts = [...menDocs, ...womenDocs];
    filteredProducts = allProducts;
    _productsController.add(filteredProducts); // Notify listeners about the data change
  }
 
  void filterProducts(String searchTerm) { 
    if (searchTerm.trim().isEmpty) {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts
          .where((product) => product['name'].toString().toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
    _productsController.add(filteredProducts); // Notify listeners about the data change
  }
}

