import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/buy.dart';
import '../../model/product.dart';


class BuyPage extends StatefulWidget {
  final DocumentSnapshot productSnapshot;

  const BuyPage(this.productSnapshot, {Key? key}) : super(key: key);

  @override
  BuyPageState createState() => BuyPageState();
}
 
class BuyPageState extends State<BuyPage> {

  late BuyController _controller;
  
  
 
  @override
  void initState() {
    _controller = BuyController(context, widget.productSnapshot);
    print('Stock value from initState: ${_controller.stock}'); // Pass context here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = _controller.product;
    final List<String> sizes = _controller.sizes;
    // final int quantity = _controller.quantity;
    final String selectedSize = _controller.selectedSize;
    // final int selectedAddressIndex = _controller.selectedAddressIndex;
    // final int stock = _controller.stock;
    final bool isFlagSet = _controller.isFlagSet;
    final bool isFormValid = _controller.isFormValid;
    

    return Scaffold(
      appBar:AppBar(title: const Text("BUY NOW ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: RefreshIndicator( 
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Product Name: ${product.productName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Price: \$${product.productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description: ${product.productDescription}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FutureBuilder<int>(
                    future: _controller.getProductQuantity(widget.productSnapshot.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData) {
                        return const Text('Error loading quantity.');
                      }

                      int quantity = snapshot.data!;

                      double totalprice = product.productPrice * quantity;
                      return RefreshIndicator(
                        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
                        child: Column(
                          children: [
                            Text(
                              'Quantity: $quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                                  onPressed: () {
                                    _controller.incrementQuantity(widget.productSnapshot.id,
                                                 _controller.quantity,
                                                 _controller.stock, );
                                  setState(() {
                                    
                                  });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                                  onPressed: () {
                                    _controller.decrementQuantity(
                                      widget.productSnapshot.id,
                                    _controller.quantity,
                                    );
                                    setState(() {
                                      
                                    });
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Total Price: \$${totalprice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Select an address:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _controller.addresses != null
                      ? _controller.addresses!
                      : const Text(
                          'No addresses found.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                    onPressed: () {
                      _controller.navigateToAddress(context);
                      
                    },
                    child: const Text('Add Address'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Select a size:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sizes.map((size) {
                      return ElevatedButton(
                        onPressed: () {
                          _controller.updateSelectedSize(size);
                          setState(() {
                            
                          });
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedSize == size ? Colors.red : Colors.black , 
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: selectedSize == size ? Colors.white : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                           style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                      
                        onPressed: () {
                          _controller.navigateToPayment(context);
                        },
                        child: const Text('Add Payment'),
                      ),
                      const SizedBox(width: 10),
                      isFlagSet ? const Icon(Icons.check, color: Colors.black) : const Icon(Icons.block_flipped, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center( 
                    child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.black ,
                ),
                      onPressed: isFormValid ? () => _controller.placeOrder(widget.productSnapshot) : null,
                      child: const Text('Place order'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
