// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:relt/view/productdetail.dart';


// class Search extends StatefulWidget {
//   const Search({Key? key}) : super(key: key);

//   @override
//   SearchState createState() => SearchState();
// }

// class SearchState extends State<Search> {
//   late List<DocumentSnapshot> allProducts;
//   late List<DocumentSnapshot> filteredProducts;
//   late TextEditingController searchController;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     searchController = TextEditingController();
//   }

//   Future<void> fetchProducts() async {
//     QuerySnapshot menSnapshot = await FirebaseFirestore.instance.collection('men').get();
//     QuerySnapshot womenSnapshot = await FirebaseFirestore.instance.collection('women').get();

//     List<DocumentSnapshot> menDocs = menSnapshot.docs;
//     List<DocumentSnapshot> womenDocs = womenSnapshot.docs;

//     setState(() {
//       allProducts = [...menDocs, ...womenDocs];
//       filteredProducts = allProducts;
//       isLoading = false;
//     });
//   }

//   void filterProducts(String searchTerm) {
//     setState(() {
//       if (searchTerm.trim().isEmpty) {
//         filteredProducts = allProducts;
//       } else {
//         filteredProducts = allProducts
//             .where((product) =>
//                 product['name'].toString().toLowerCase().contains(searchTerm.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Search'),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: searchController,
//                   onChanged: filterProducts,
//                   decoration: const InputDecoration(
//                     labelText: 'Search',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot product = filteredProducts[index];

//                     // Replace with your custom product tile widget
//                     return ListTile(
//                       title: Text(product['name'].toString()),
//                       subtitle: Text(product['description'].toString()),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ProductDetailScreen(product),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//           if (isLoading)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
