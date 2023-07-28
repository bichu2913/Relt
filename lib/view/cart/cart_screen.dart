import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relt/controller/cart_page.dart';
import 'package:relt/model/cart_page.dart';
import 'package:relt/view/productdetail.dart';
import 'buypage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = CartController();

  @override 
  void initState() {
    super.initState();
    _cartController.initializeCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
     appBar: AppBar(title: const Text("CART ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: RefreshIndicator(
        onRefresh: _cartController.initializeCartData,
        child: StreamBuilder<CartModel>(
          stream: _cartController.cartModelStream,
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

            CartModel cartModel = snapshot.data!;

            if (cartModel.cartProducts.isEmpty) {
              return const Center(
                child: Text('No products in cart'),
              );
            }

            return CartProductList(
              cartModel: cartModel,
              cartController: _cartController,
            );
          },
        ),
      ),
    );
  }
}

class CartProductList extends StatefulWidget {
  final CartModel cartModel;
  final CartController cartController;

  const CartProductList({
    required this.cartModel,
    required this.cartController,
    Key? key,
  }) : super(key: key);

  @override
  State<CartProductList> createState() => _CartProductListState();
}

class _CartProductListState extends State<CartProductList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartModel.cartProducts.length,
            itemBuilder: (context, index) {
              DocumentSnapshot productSnapshot = widget.cartModel.cartProducts[index];
              Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

              if (data == null) {
                return const SizedBox();  
              }

              String name = data['name'] as String? ?? '';
              double price = (data['price'] as num?)?.toDouble() ?? 0.0;
              List<dynamic>? imageUrls = data['images'] as List<dynamic>?;

              String imageUrl =
                  imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

              int stock = (data['stock'] as int?) ?? 0;
              int quantity = index < widget.cartModel.quantities.length ? widget.cartModel.quantities[index] : 0;

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
                    widget.cartController.deleteProductFromCart(productSnapshot);
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
                      ],
                    ),
                    title: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    subtitle: Text(
                      '₹ ${price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
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
                                if (index < widget.cartModel.quantities.length) {
                                  widget.cartModel.quantities[index] = quantity;
                                }
                              }
                              widget.cartController.updateQuantityInDatabase(productSnapshot.id, quantity);
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
                                if (index < widget.cartModel.quantities.length) {
                                  widget.cartModel.quantities[index] = quantity;
                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                          ),
                          content: SizedBox(
                            height: 59,
                            child: Center(
                              child: Text(
                                "Selected Maximum number of Product ! ", 
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                              }
                              widget.cartController.updateQuantityInDatabase(productSnapshot.id, quantity);
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
            '₹ ${widget.cartModel.getTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
          onPressed: () {
            List<DocumentSnapshot> selectedProducts = [];
            List<int> selectedQuantities = [];
            double total = 0.0;

            for (int i = 0; i < widget.cartModel.cartProducts.length; i++) {
              if (widget.cartModel.quantities[i] > 0) {
                selectedProducts.add(widget.cartModel.cartProducts[i]);
                selectedQuantities.add(widget.cartModel.quantities[i]);

                DocumentSnapshot productSnapshot = widget.cartModel.cartProducts[i];
                Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

                if (data != null) {
                  double price = (data['price'] as num?)?.toDouble() ?? 0.0;
                  int quantity = widget.cartModel.quantities[i];
                  total += price * quantity;
                }
              }
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyPage(
                  selectedProducts: selectedProducts,
                  quantities: selectedQuantities,
                  totalPrice: total, 
                ),
              ),
            ); 
          },
          child: const Text('Place Order'),
        ),
        ListTile(
          title: const Text(
            'Total Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '₹ ${widget.cartModel.getTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
