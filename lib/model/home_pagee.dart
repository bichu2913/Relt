

// home_page_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relt/firebase/firebasedata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();
  User? currentUser;

  HomePageModel();

  Future<void> signUserOut() async {
    await _auth.signOut();
  } 

  Future<User?> getCurrentUser() async {
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<List<DocumentSnapshot>> getFeaturedData() async {
    return _firebaseService.getFeatured();
  }

  Future<List<DocumentSnapshot>> getRecentlyData() async {
    return _firebaseService.getrecentalyData();
  }

  Future<List<DocumentSnapshot>> getAllProductsData() async {
    return _firebaseService.getProducts();
  }
}

