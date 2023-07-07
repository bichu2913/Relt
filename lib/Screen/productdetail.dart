import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/buy/buy.dart';

import 'package:relt/Screen/cart/cartmanager.dart';

class ProductDetailScreen extends StatefulWidget {
  final DocumentSnapshot productSnapshot;

  const ProductDetailScreen(this.productSnapshot, {Key? key}) : super(key: key);

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer();
    saveRecentlyViewedProduct();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < widget.productSnapshot['images'].length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
Future<void> saveRecentlyViewedProduct() async {
   final user = FirebaseAuth.instance.currentUser!;
  String productId = widget.productSnapshot.id;
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user.email);

  try {
    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      // User document exists
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> recentlyViewed = userData['recentlyViewed'] ?? [];
      if (!recentlyViewed.contains(productId)) {
        // Product ID does not exist in the array, update the field
        recentlyViewed.add(productId);
        await userRef.update({'recentlyViewed': FieldValue.arrayUnion([productId])});
      }
    } else {
      // User document does not exist, create it
      await userRef.set({'recentlyViewed': [productId]});
    }
  } catch (error) {
    print('Failed to save recently viewed product: $error');
  }
}
void navigateToBuy(DocumentSnapshot productSnapshot) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>  Buy(productSnapshot, toggleFlagCallback: () {  },)),
  );
}







  @override
  Widget build(BuildContext context) {
    List<dynamic>? imageUrls = widget.productSnapshot['images'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls?.length ?? 0,
              itemBuilder: (context, index) {
                String imageUrl = imageUrls?[index] as String? ?? '';

                return Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.productSnapshot['name'] as String? ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: \$${(widget.productSnapshot['price'] as num?)?.toStringAsFixed(2) ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Description: ${widget.productSnapshot['description'] as String? ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
 ElevatedButton(
  onPressed: ()   {
    navigateToBuy(widget.productSnapshot);
  },
  
  child: const Text('Buy Now'),
),


                    ElevatedButton(
                      onPressed: () {
                        CartManager cartManager = CartManager();
                        cartManager.toggleCartStatus(widget.productSnapshot, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added to cart')),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


