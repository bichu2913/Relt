import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final List<DocumentSnapshot<Object?>> wishlistProducts;

  WishlistModel({required this.wishlistProducts});
}
