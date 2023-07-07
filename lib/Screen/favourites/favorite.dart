import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relt/firebase/firebasedata.dart';


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

          print('Wishlist Length: ${wishlist.length}');

          List<DocumentSnapshot<Object?>> products = await firebaseService.getProducts();

          print('All Products Length: ${products.length}');

          List<DocumentSnapshot<Object?>> wishlistProducts = products
              .where((product) => wishlist.contains(product.id))
              .toList();

          print('Filtered Products Length: ${wishlistProducts.length}');

          return wishlistProducts;
        }
      }

      return [];
    } catch (e) {
      print('Error retrieving wishlist data: $e');
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

