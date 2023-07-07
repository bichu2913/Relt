import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/address/address.dart';
import 'package:relt/Screen/buy/payment.dart';


class AddressList extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');
  final String userId;
   final VoidCallback toggleFlagCallback;

  AddressList({required this.userId, required this.toggleFlagCallback});

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int selectedAddressIndex = -1; // Index of the selected address, -1 means none selected

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>( 
      stream: widget.usersCollection.doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No addresses found.');
        }

        Map<String, dynamic>? userData = snapshot.data?.data();
        List<dynamic> addresses = (userData?['addresses'] ?? []) as List<dynamic>;

        if (addresses.isEmpty) {
          return const Text('No addresses found.');
        }

        return Column(
          children: List.generate(addresses.length, (index) {
            Map<String, dynamic> address = addresses[index] as Map<String, dynamic>;

            return RadioListTile(
              title: Text(address['address'] as String),
              subtitle: Text('${address['city']}, ${address['phone']}'),
              value: index,
              groupValue: selectedAddressIndex,
              onChanged: (value) {
                setState(() {
                  selectedAddressIndex = value as int;
                });
              },
            );
          }),
        );
      },
    );
  }
}

class Buy extends StatefulWidget {
  final DocumentSnapshot productSnapshot;
  final VoidCallback toggleFlagCallback;


  Buy(this.productSnapshot, {Key? key, required this.toggleFlagCallback}) : super(key: key);

  @override
  BuyState createState() => BuyState();
}

class BuyState extends State<Buy> {
  final user = FirebaseAuth.instance.currentUser!;
  int selectedAddressIndex = -1; // Index of the selected address, -1 means none selected
  AddressList? addresses;
  

  String selectedSize = ''; // Selected size, empty string means none selected
  List<String> sizes = ['S', 'M', 'L', 'XL'];
  int quantity = 1;
  int stock = 0; 
   bool isFlagSet = false;

  @override
  void initState() {
    super.initState(); 
    fetchAddresses();
    fetchStock();
    
  }
  void toggleFlag() {
    setState(() {
      isFlagSet = true;
    });
  }
   Future<void> fetchStock() async {
    try {
      // Fetch the stock from Firestore or any other data source
      String productId = widget.productSnapshot.id;
      DocumentSnapshot<Object?> productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        Map<String, dynamic>? productData = productSnapshot.data() as Map<String, dynamic>?;
        stock = productData?['stock'] as int? ?? 0;
      }
    } catch (e) {
      print('Error fetching stock: $e');
    }
  }
  

void incrementQuantity(String productId, int currentQuantity, int stock) async {
    try {
      // Increment the quantity if stock is available
      if (currentQuantity < stock) {
        int newQuantity = currentQuantity + 1;

        // Update the quantity in the state
        setState(() {
          quantity = newQuantity;
        });

        // Update the quantity in the Firestore database
        await updateQuantityInDatabase(productId, newQuantity);
      } else {
        // Show a snackbar indicating insufficient stock
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient stock.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error incrementing quantity: $e');
    }
  }
  Future<void> updateQuantityInDatabase(String productId, int quantity) async {
  try {
    // Implement the logic to update the quantity in the database
    // You can use the FirebaseFirestore instance to access the database and update the corresponding document
    
    // Example code to update the quantity in Firestore
    String? userId = user.email;
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Get the current cart data
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
    Map<String, dynamic>? userData = userSnapshot.data();
    List<dynamic> cart = userData?['cart'] ?? [];

    // Find the product in the cart
    int index = cart.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      // Update the quantity
      cart[index]['quantity'] = quantity;

      // Update the cart data in Firestore
      await userRef.update({'cart': cart});
    }
  } catch (e) {
    print('Error updating quantity in the database: $e');
  }
}










  void decrementQuantity(String productId, int quantity) async {
    try {
      String? userId = user.email;
      DocumentReference<Map<String, dynamic>> userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the current cart data
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
      Map<String, dynamic>? userData = userSnapshot.data();
      List<dynamic> cart = userData?['cart'] ?? [];

      // Check if the product is in the cart
      int index = cart.indexWhere((item) => item['productId'] == productId);
      if (index != -1) { 
        // Decrement the quantity if it's greater than 1
        if (cart[index]['quantity'] > 1 ) { 
          cart[index]['quantity'] = cart[index]['quantity'] - 1;
        } 

        // Update the cart data in Firestore
        await userRef.update({'cart': cart});
      }
      setState(() {});
    } catch (e) {
      print('Error decrementing quantity: $e');
    }
  }
  

Future<int> getProductQuantity(String productId) async {
  try {
    String? userId = user.email;
    DocumentSnapshot<Object?> userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        int index = cart
            .indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          return cart[index]['quantity'] as int? ?? 0;
        }
      }
    }
  } catch (e) {
    print('Error getting product quantity: $e');
  }

  return 0;
}


  void fetchAddresses() async {
    try {
      String? userId = user.email;
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // List<Map<String, dynamic>> addressData = userSnapshot.data()?['addresses'] ?? [];
        // List<String> fetchedAddresses =
        //     addressData.map((address) => address['address'] as String).toList();
        setState(() {
          addresses = AddressList(userId: userId as String, toggleFlagCallback: () {  },);
        });
      }
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  void navigateToAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAddressPage(),
      ),
    );
  }
   void navigateToPayment() {
    double totalPrice = widget.productSnapshot['price'] * quantity;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(totalPrice: totalPrice, toggleFlagCallback: () {  },),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = widget.productSnapshot.data() as Map<String, dynamic>?;

    // Retrieve the product details from the productSnapshot
    List<dynamic>? imageUrls = data?['images'] as List<dynamic>?;
    final String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';
    final String productName = data?['name'] as String? ?? '';
    final double productPrice = data?['price'] as double? ?? 0.0;
    final String productDescription = data?['description'] as String? ?? '';
    final int stock =data?['stock'];
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Page'),
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
                  // Display the product image
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  // Display the product details
                  Text(
                    'Product Name: $productName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Price: \$${productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description: $productDescription',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   const SizedBox(height: 16),
      FutureBuilder<int>(
        future: getProductQuantity(widget.productSnapshot.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
          }
      
          if (!snapshot.hasData) {
        return const Text('Error loading quantity.');
          }
      
          int quantity = snapshot.data!;
      
          
          double totalprice=productPrice * quantity;
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
                  onPressed: () {
                   incrementQuantity(widget.productSnapshot.id, snapshot.data ?? 0,stock);
                   
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    decrementQuantity(widget.productSnapshot.id, snapshot.data ?? 0);
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              'Total Price: \$${(totalprice).toStringAsFixed(2)}',
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
                  addresses != null ? addresses! : const Text(
                    'No addresses found.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      navigateToAddress();
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
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedSize == size ? Colors.red : null,
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
                        onPressed: () {
                          
                          navigateToPayment();
                        },
                        child: const Text('Add Payment '),
                      ),
                       const SizedBox(width: 10),
                      isFlagSet ? const Icon(Icons.check,color: Colors.black,) :  const Icon(Icons.block_flipped,color: Colors.black,)
                    ],
                  ),
                  const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            
                          },
                          child: const Text('Place order '),
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
 
