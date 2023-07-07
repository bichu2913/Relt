import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/cart/cartmanager.dart';
import 'package:relt/Screen/productdetail.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartManager cartManager = CartManager();
  late Future<List<DocumentSnapshot<Object?>>> _cartDataFuture;

  @override
  void initState() {
    super.initState();
    _cartDataFuture = cartManager.getCartData();
  }

  Future<void> _refreshCartData() async {
    setState(() {
      _cartDataFuture = cartManager.getCartData();
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCartData,
        child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
          future: _cartDataFuture,
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

            List<DocumentSnapshot<Object?>> cartProducts = snapshot.data ?? [];

            if (cartProducts.isEmpty) {
              return const Center(
                child: Text('No products in cart'),
              );
            }

            return CartProductList(cartProducts, refreshCartData: _refreshCartData);
          },
        ),
      ),
    );
  }
}

class CartProductList extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> cartProducts;
  final VoidCallback refreshCartData;

  const CartProductList(this.cartProducts, {required this.refreshCartData, Key? key})
      : super(key: key);

  @override
  State<CartProductList> createState() => _CartProductListState();
}

class _CartProductListState extends State<CartProductList> {
  final CartManager cartManager = CartManager();
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    initializeQuantities();
  }

  Future<void> initializeQuantities() async {
    List<int> updatedQuantities = [];

    for (int i = 0; i < widget.cartProducts.length; i++) {
      DocumentSnapshot<Object?> productSnapshot = widget.cartProducts[i];
      String productId = productSnapshot.id;
      int quantity = await cartManager.getQuantity(productId);
      updatedQuantities.add(quantity);
    }

    setState(() {
      quantities = updatedQuantities;
    });
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < widget.cartProducts.length; i++) {
      DocumentSnapshot<Object?> productSnapshot = widget.cartProducts[i];
      Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        double price = (data['price'] as num?)?.toDouble() ?? 0.0;
        int quantity = quantities[i];
        totalPrice += price * quantity;
      }
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartProducts.length,
            itemBuilder: (context, index) {
              DocumentSnapshot<Object?> productSnapshot = widget.cartProducts[index];
              Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

              if (data == null) {
                return const SizedBox.shrink();
              }

              String name = data['name'] as String? ?? '';
              double price = (data['price'] as num?)?.toDouble() ?? 0.0;
              List<dynamic>? imageUrls = data['images'] as List<dynamic>?;

              String imageUrl =
                  imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

              int stock = (data['stock'] as int?) ?? 0;
              int quantity = quantities[index];

              return Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Dismissible(
                  key: Key(productSnapshot.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteProductFromCart(context, productSnapshot);
                  },
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          left: 2,
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                if (quantity < stock) {
                                  quantity++;
                                  quantities[index] = quantity;
                                }
                                 updateQuantityInDatabase(productSnapshot.id, quantity);
                              });
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  quantities[index] = quantity;
                                }
                                updateQuantityInDatabase(productSnapshot.id, quantity);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      name,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      '\$${price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                                quantities[index] = quantity;
                              }
                               updateQuantityInDatabase(productSnapshot.id, quantity);
                            });
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if (quantity < stock) {
                                quantity++;
                                quantities[index] = quantity;
                              }
                               updateQuantityInDatabase(productSnapshot.id, quantity);
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(productSnapshot),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Total Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '\$${getTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Place order logic here
          },
          child: const Text('Place Order'),
        ),
      ],
    );
  }

Future<void> _deleteProductFromCart(
    BuildContext context, DocumentSnapshot<Object?> productSnapshot) {
  return cartManager.deleteItemFromCart( productSnapshot).then((_) {
    setState(() {
      widget.cartProducts.removeWhere((snapshot) =>
          snapshot.reference == productSnapshot.reference);
      initializeQuantities();
    }); 
  });
}



  Future<void> updateQuantityInDatabase(String productId, int quantity) {
    return cartManager.updateQuantity(productId, quantity);
  } 
}
