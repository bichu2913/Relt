import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/favourites/favorite.dart';
import 'package:relt/Screen/productdetail.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> { 
  final WishlistManager wishlistManager = WishlistManager();
  late Future<List<DocumentSnapshot<Object?>>> _wishlistDataFuture;

  @override
  void initState() {
    super.initState();
    _wishlistDataFuture = wishlistManager.getWishlistData();
  }

  Future<void> _refreshWishlistData() async {
    setState(() {
      _wishlistDataFuture = wishlistManager.getWishlistData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWishlistData,
        child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
          future: _wishlistDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<DocumentSnapshot<Object?>> wishlistProducts = snapshot.data ?? [];

            if (wishlistProducts.isEmpty) {
              return const Center(
                child: Text('No products in wishlist'),
              );
            }

            return CategoryTile(snapshot);
          },
        ),
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  final AsyncSnapshot<List<DocumentSnapshot<Object?>>> snapshot;

  const CategoryTile(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  List<bool> favoriteList = [];
  WishlistManager wishlistManager = WishlistManager();

  @override
  void initState() {
    super.initState();
    initializeFavorites();
  }

  Future<void> initializeFavorites() async {
    try {
      List<DocumentSnapshot<Object?>> wishlistData = await wishlistManager.getWishlistData();
      List<String> wishlistProductIds =
          wishlistData.map((documentSnapshot) => documentSnapshot.id).toList();

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
        List<dynamic>? imageUrls = data['images'] as List<dynamic>?;

        String imageUrl =
            imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

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
                      _showDeleteConfirmationDialog(context, productSnapshot);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, DocumentSnapshot<Object?> productSnapshot) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this product from the wishlist?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteProductFromWishlist(context, productSnapshot);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProductFromWishlist(
      BuildContext context, DocumentSnapshot<Object?> productSnapshot) {
    WishlistManager wishlistManager = WishlistManager();
    wishlistManager.toggleWishlistStatus(productSnapshot, false).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product removed from wishlist')),
      );
      setState(() {
        widget.snapshot.data!.remove(productSnapshot);
      });
      Navigator.of(context).pop();
    });
  }
}













