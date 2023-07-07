import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/favourites/favorite.dart';
import 'package:relt/Screen/productdetail.dart';

class Categorytile extends StatefulWidget {
  final AsyncSnapshot<List<DocumentSnapshot<Object?>>> snapshot;
  

  const Categorytile(this.snapshot, {Key? key}) : super(key: key);

  @override
  CategorytileState createState() => CategorytileState();
}

class CategorytileState extends State<Categorytile> {
  List<bool> favoriteList = [];
  WishlistManager wishlistManager = WishlistManager();

  @override
  void initState() {
    super.initState();
    initializeFavorites();
  }

  Future<void> initializeFavorites() async {
    try {
      List<DocumentSnapshot<Object?>> wishlistData =
          await wishlistManager.getWishlistData();
      List<String> wishlistProductIds = wishlistData
          .map((documentSnapshot) => documentSnapshot.id)
          .toList();

      setState(() {
        favoriteList = List<bool>.generate(
          widget.snapshot.data!.length,
          (index) => wishlistProductIds.contains(widget.snapshot.data![index].id),
        );
      });
    } catch (e) {
      print('Error initializing favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return GridView.builder(
      itemCount: widget.snapshot.data!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        DocumentSnapshot<Object?> productSnapshot = widget.snapshot.data![index];
        Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

        if (data == null) {
          return const SizedBox.shrink();
        }

        String name = data['name'] as String? ?? '';
        double price = (data['price'] as num?)?.toDouble() ?? 0.0;
        List<dynamic>? imageUrls = (data['images'] as List?)?.cast<dynamic>();


        String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? (imageUrls[0] as String? ?? '') : 'Loading...';


        bool isFavorite = favoriteList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(productSnapshot),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        favoriteList[index] = isFavorite;
                      });

                      wishlistManager.toggleWishlistStatus(
                        productSnapshot,
                        isFavorite,
                      );
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



