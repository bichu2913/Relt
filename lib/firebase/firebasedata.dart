import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class FirebaseService {   
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  // Fetch products from the Women collection
  Future<List<DocumentSnapshot>> getWomenProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('women')
        .get();

    return snapshot.docs;
  }
  Future<List<DocumentSnapshot>> getWomenTops() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('women')
          .where('category', isEqualTo: 'Tops')
          .get();

      return snapshot.docs;
     
    }
  
   Future<List<DocumentSnapshot>> getWomenPants() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('women')
          .where('category', isEqualTo: 'Pants')
          .get();

      return snapshot.docs;
   
  }
   Future<List<DocumentSnapshot>> getWomenAccessories() async {
  
      QuerySnapshot snapshot =  await FirebaseFirestore.instance
          .collection('women')
          .where('category', isEqualTo: 'Other Accessories')
          .get();

      return snapshot.docs;
    
  }
  Future<List<DocumentSnapshot>> getMenProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('men')
        .get();

    return snapshot.docs;
  }
  Future<List<DocumentSnapshot>> getMenShirts() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('men')
          .where('category', isEqualTo: 'Shirt')
          .get();

      return snapshot.docs;
     
    }
    Future<List<DocumentSnapshot>> getMenPants() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('men')
          .where('category', isEqualTo: 'Pants')
          .get();

      return snapshot.docs;
   
  }
   Future<List<DocumentSnapshot>> getMenAccessories() async {
  
      QuerySnapshot snapshot =  await FirebaseFirestore.instance
          .collection('men')
          .where('category', isEqualTo: 'Accessories')
          .get();

      return snapshot.docs;
    
  } 
  Future<List<DocumentSnapshot>> getProducts() async {
  QuerySnapshot menSnapshot = await FirebaseFirestore.instance
      .collection('men')
      .get();

  QuerySnapshot womenSnapshot = await FirebaseFirestore.instance
      .collection('women')
      .get();

  List<DocumentSnapshot> menDocs = menSnapshot.docs;
  List<DocumentSnapshot> womenDocs = womenSnapshot.docs;

  List<DocumentSnapshot> allDocs = [...menDocs, ...womenDocs];

  return allDocs;
}
Future<List<DocumentSnapshot<Object?>>> getrecentalyData() async {
    try {
      String? userId = user.email;

      DocumentSnapshot<Object?> userSnapshot =
          await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('recentlyViewed')) {
          List<dynamic> recentlyViewed = userData['recentlyViewed'] as List<dynamic>;

          print('recentlyViewed Length: ${recentlyViewed.length}');

          List<DocumentSnapshot<Object?>> products =
              await getProducts();

          print('All Products Length: ${products.length}');

          List<DocumentSnapshot<Object?>> recentlyViewedProducts = products
              .where((product) => recentlyViewed.contains(product.id))
              .toList();

          print('Filtered Products Length: ${recentlyViewed.length}');

          return recentlyViewedProducts;
        }
      }

      return [];
    } catch (e) {
      print('Error retrieving cart data: $e');
      return [];
    }
  }
    Future<List<DocumentSnapshot>> getFeatured() async {
  QuerySnapshot menSnapshot = await FirebaseFirestore.instance
      .collection('men')
      .where('featured', isEqualTo: true)
      .get();

  QuerySnapshot womenSnapshot = await FirebaseFirestore.instance
      .collection('women')
      .where('featured', isEqualTo: true)
      .get();

  List<DocumentSnapshot> menDocs = menSnapshot.docs;
  List<DocumentSnapshot> womenDocs = womenSnapshot.docs;

  List<DocumentSnapshot> featuredDocs = [...menDocs, ...womenDocs];

  return featuredDocs;
}


}
