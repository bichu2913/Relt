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

        

          List<DocumentSnapshot<Object?>> products =
              await getProducts();

       

          List<DocumentSnapshot<Object?>> recentlyViewedProducts = products
              .where((product) => recentlyViewed.contains(product.id))
              .toList();


          return recentlyViewedProducts;
        }
      }

      return [];
    } catch (e) {
      
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
Future<DocumentSnapshot<Map<String, dynamic>>> getOrderData() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final String? userId = user.email;

    return FirebaseFirestore.instance.collection('orders').doc(userId).get();
  }

  Future<List<DocumentSnapshot>> getMatchingProducts(List<dynamic> productIds) async {
    List<DocumentSnapshot> allDocs = await getProducts();

    List<DocumentSnapshot> matchingProducts = [];

    for (var productId in productIds) {
      DocumentSnapshot? matchingProduct = allDocs.firstWhere((doc) => doc.id == productId, );
      matchingProducts.add(matchingProduct);
    }

    return matchingProducts;
  }
Future<void> updateProduct(String productId, int newStock) async {
  List<DocumentSnapshot> updatedProducts = await getMatchingProducts([productId]);

  if (updatedProducts.isNotEmpty) {
    DocumentSnapshot product = updatedProducts.first;

    // Update the status field with the new value
    await product.reference.update({'stock': newStock});

    // Fetch the updated document snapshot
    DocumentSnapshot updatedProduct = await product.reference.get();

    // Retrieve the updated field value
     int? updatedStatus = updatedProduct.get('stock') as int?;

    // Do something with the updated status
    if (updatedStatus != null) {
     
    }
  } else {
  
  }
}
Future<void> updateProductStatus(String productId, String newStatus) async {
  final User user = FirebaseAuth.instance.currentUser!;
  final String? userId = user.email;
  final DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc(userId);

   DocumentSnapshot<Map<String, dynamic>> orderSnapshot = await orderRef.get() as DocumentSnapshot<Map<String, dynamic>>;

  if (orderSnapshot.exists) {
    Map<String, dynamic>? orderData = orderSnapshot.data();
    List<dynamic>? products = orderData?['products'] as List<dynamic>?;
    
    if (products != null) {
      for (int i = 0; i < products.length; i++) {
        String? currentProductId = products[i]['productId'] as String?;

        if (currentProductId == productId) {
          products[i]['status'] = newStatus;
          break; // Exit the loop once the product is found and updated
        }
      }

      await orderRef.update({'products': products});
      
    } else {
       
    }
  } else {
    
  }
}
Future<void> saveRecentlyViewedProduct(productSnapshot) async {
    final user = FirebaseAuth.instance.currentUser!;
    String productId = productSnapshot.id;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user.email);

    try {
      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        // User document exists
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        List<dynamic> recentlyViewed = userData['recentlyViewed'] ?? [];
        if (!recentlyViewed.contains(productId)) {
          // Product ID does not exist in the array, update the field
          recentlyViewed.add(productId);
          await userRef
              .update({'recentlyViewed': FieldValue.arrayUnion([productId])});
        }
      } else {
        // User document does not exist, create it
        await userRef.set({'recentlyViewed': [productId]});
      }
    } catch (error) {
     [];
    }
  }
  





 



}
