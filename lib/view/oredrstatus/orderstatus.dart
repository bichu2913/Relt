import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebasedata.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({Key? key}) : super(key: key);

  @override
  State<OrderStatusPage> createState() => OrderStatusPageState();
}

class OrderStatusPageState extends State<OrderStatusPage> {
  bool isDataLoaded = false;

  final FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    void refreshUI() {
      setState(() {
        isDataLoaded = true;
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("ORDER STATUS ",textAlign: TextAlign.center ,),backgroundColor: Colors.black, 
    
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firebaseService.getOrderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // Retrieve order data from the snapshot
            Map<String, dynamic>? orderData = snapshot.data?.data();
            List<dynamic>? products = orderData?['products'] as List<dynamic>?;

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Order Status',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ), 
                    ),
                    const SizedBox(height: 16),
                    if (products != null)
                      Column(
                        children: products.map((product) {
                          String productId = product['productId'] as String;
                          int quantity = product['quantity'] as int;
                          double total = (product['total'] as num).toDouble();

                          String size = product['selectedSize'] as String;
                          String status = product['status'] as String;

                          return FutureBuilder<List<DocumentSnapshot>>(
                            future: firebaseService
                                .getMatchingProducts([productId]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snapshot.hasData) {
                                List<DocumentSnapshot> matchingProducts =
                                    snapshot.data!;
                                if (matchingProducts.isNotEmpty) {
                                  DocumentSnapshot productSnapshot =
                                      matchingProducts.first;
                                  // Retrieve other fields from the product document
                                  String productName =
                                      productSnapshot['name'] as String;
                                  int productstock =
                                      productSnapshot['stock'] as int;

                                  return SizedBox(
                                    width: 343,
                                    height: 164,
                                    child: Stack(  
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 343,
                                            height: 164,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.12),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 24,
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 118,
                                          left: 254,
                                          child: Text(
                                            status,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  42, 169, 82, 1),
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1.4285714285714286,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 18,
                                          left: 28,
                                          child: Text(
                                            productName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(34, 34, 34, 1),
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 74,
                                          left: 25,
                                          child: SizedBox(
                                            width: 77,
                                            height: 20,
                                            child: Stack(
                                              children: [
                                                const Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Text(
                                                    'Quantity:',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          155, 155, 155, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.4285714285714286,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 3,
                                                  left: 60,
                                                  child: Text(
                                                    '$quantity',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          34, 34, 34, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 28,
                                          child: SizedBox(
                                            width: 214,
                                            height: 20,
                                            child: Stack(
                                              children: [
                                                const Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Text(
                                                    'Size:',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          155, 155, 155, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.4285714285714286,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 40,
                                                  child: Text(
                                                    size,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          34, 34, 34, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.4285714285714286,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 74,
                                          left: 186,
                                          child: SizedBox(
                                            width: 133,
                                            height: 20,
                                            child: Stack(
                                              children: [
                                                const Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Text(
                                                    'Total Amount:',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          155, 155, 155, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 14,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height:
                                                          1.4285714285714286,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 3,
                                                  left: 92,
                                                  child: Text(
                                                    '\$$total',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          34, 34, 34, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 18,
                                          left: 254,
                                          child: PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  title: const Text('cancel'),
                                                  onTap: () {
                                                    String newStatus =
                                                        'Cancelled';
                                                    firebaseService
                                                        .updateProductStatus(
                                                            productId,
                                                            newStatus);
                                                    int newstock =
                                                        productstock + quantity;
                                                    firebaseService
                                                        .updateProduct(
                                                            productId,
                                                            newstock);
                                                    refreshUI();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }

                              return const Text(
                                  'Failed to fetch product details.');
                            },
                          );
                        }).toList(),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        // Add any necessary navigation logic here
                      },
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Failed to fetch order data.'),
          );
        },
      ),
    );
  }
}
