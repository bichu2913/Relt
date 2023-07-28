import 'dart:async';   
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relt/firebase/firebasedata.dart';
import 'package:relt/model/favourite_page.dart';
class WishlistController {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseService firebaseService = FirebaseService();

  final _wishlistModelController = StreamController<WishlistModel?>.broadcast();
  Stream<WishlistModel?> get wishlistModelStream => _wishlistModelController.stream;

  Future<void> initializeWishlistData() async {
    try {
      List<DocumentSnapshot> wishlistProducts = await getWishlistData();
      WishlistModel wishlistModel = WishlistModel(wishlistProducts: wishlistProducts);
      _wishlistModelController.sink.add(wishlistModel);
    } catch (e) {
      print('Error initializing wishlist data: $e');
      _wishlistModelController.sink.add(null);
    }
  }

  Future<List<DocumentSnapshot>> getWishlistData() async {
    try {
      String? userId = user.email;

      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('wishlist')) {
          List<dynamic> wishlist = userData['wishlist'] as List<dynamic>;

          List<DocumentSnapshot> products = await firebaseService.getProducts();

          List<DocumentSnapshot> wishlistProducts = [];

          for (var wishlistItem in wishlist) {
            String productId = wishlistItem;

            for (var product in products) {
              if (productId == product.id) {
                wishlistProducts.add(product);
                break; // Break the inner loop if a match is found
              }
            }
          }

          return wishlistProducts;
        }
      }

      return [];
    } catch (e) {
      print('Error retrieving wishlist data: $e');
      return [];
    }
  }

  Future<void> toggleWishlistStatus(DocumentSnapshot productSnapshot, bool isFavorite) async {
    try {
      String? userId = user.email;

      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('wishlist')) {
          List<dynamic> wishlist = userData['wishlist'] as List<dynamic>;
          String productId = productSnapshot.id;

          if (wishlist.contains(productId)) {
            wishlist.remove(productId);
          } else {
            wishlist.add(productId);
          }

          await usersCollection.doc(userId).set(
            {'wishlist': wishlist},
            SetOptions(merge: true),
          );
        } else {
          List<String> wishlist = [productSnapshot.id];

          await usersCollection.doc(userId).set(
            {'wishlist': wishlist},
            SetOptions(merge: true),
          );
        }

        // Refresh wishlist data after toggle
        initializeWishlistData();
      }
    } catch (e) {
      print('Error toggling wishlist status: $e');
    }
  }

  Future<void> deleteProductFromWishlist(DocumentSnapshot productSnapshot) async {
    try {
      String? userId = user.email;
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('wishlist')) {
          List<dynamic> wishlist = userData['wishlist'] as List<dynamic>;
          String productId = productSnapshot.id;

          if (wishlist.contains(productId)) {
            wishlist.remove(productId);
            await usersCollection.doc(userId).update({'wishlist': wishlist});
          }
        }
      }
    } catch (e) {
      print('Error deleting product from wishlist: $e');
    }
  }

  void dispose() {
    _wishlistModelController.close();
  }
  WishlistModel getWishlistModel() {
    return WishlistModel(wishlistProducts: []);
  }
} 

class WishlistManager {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      final FirebaseService firebaseService = FirebaseService();

  Future<void> toggleWishlistStatus(
    DocumentSnapshot<Object?> productSnapshot,
    bool isFavorite,
  ) async {
    try {
      String? userId = user.email;

      DocumentSnapshot<Object?> userSnapshot =
          await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('wishlist')) {
          List<dynamic> wishlist = userData['wishlist'] as List<dynamic>;
          String productId = productSnapshot.id;

          if (wishlist.contains(productId)) {
            wishlist.remove(productId);
          } else { 
            wishlist.add(productId);
          }

          await usersCollection.doc(userId).set(
            {'wishlist': wishlist},
            SetOptions(merge: true),
          );
        } else {
          List<String> wishlist = [productSnapshot.id];

          await usersCollection.doc(userId).set(
            {'wishlist': wishlist},
            SetOptions(merge: true),
          );
        }
      }
    } catch (e) {
      print('Error toggling wishlist status: $e');
    }
  }

Future<List<DocumentSnapshot<Object?>>> getWishlistData() async {
    try {
      String? userId = user.email;

      DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('wishlist')) {
          List<dynamic> wishlist = userData['wishlist'] as List<dynamic>;

          

          List<DocumentSnapshot<Object?>> products = await firebaseService.getProducts();

          

          List<DocumentSnapshot<Object?>> wishlistProducts = products
              .where((product) => wishlist.contains(product.id))
              .toList();

         

          return wishlistProducts;
        }
      }

      return [];
    } catch (e) {
      
      return [];
    }
  }

 



}
Future<List<DocumentSnapshot<Object?>>> getProducts() async {
  QuerySnapshot menSnapshot = await FirebaseFirestore.instance
      .collection('men')
      .get();

  QuerySnapshot womenSnapshot = await FirebaseFirestore.instance
      .collection('women')
      .get();

  List<DocumentSnapshot<Object?>> menDocs = menSnapshot.docs;
  List<DocumentSnapshot<Object?>> womenDocs = womenSnapshot.docs;

  List<DocumentSnapshot<Object?>> allDocs = [...menDocs, ...womenDocs];

  return allDocs;
}

