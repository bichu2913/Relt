// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:relt/view/buy/buy.dart';
// import 'package:relt/view/productdetail.dart';
// import 'package:relt/view/search.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:relt/firebase/firebasedata.dart';
// import 'package:relt/model/home_page.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class HomePage extends StatefulWidget {
  
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser!;

//    final FirebaseService firebaseService = FirebaseService();

//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
  
//   }

//   @override
//   Widget build(BuildContext context) {
     
//     final Size screenSize = MediaQuery.of(context).size;
//     final double screenWidth = screenSize.width;
//     final double screenHeight = screenSize.height;
//     return Scaffold(
//        backgroundColor: Colors.grey[300],  
//       appBar:
//        AppBar( elevation: 0, 
//         title: Center(
//             child: Text(
//               "WELCOME: ${user.email!}",
//               style: const TextStyle(fontSize: 20),
//             ),
//           ),
//         backgroundColor: Colors.grey[900],
//         actions: [
//           IconButton(
//             onPressed: signUserOut,
//             icon: const Icon(Icons.logout), 
//           ),
//         ],
//       ),
//       body: Column( 
//         children: [ 
//                 Container(
//             height: MediaQuery.of(context).size.height / 11,
//             color: Colors.grey[900],
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white),
//                 child:  InkWell(
//                   onTap:() {
//                         Navigator.push(
//                         context,
//                          MaterialPageRoute(builder: (context) => const Search()), // Navigate to Search screen
//                      );
//                   }, 
//                   child: const Row(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: Icon(Icons.search),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: Text(
//                           'Search for Products, Brands and More',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SectionTitle(title: 'Featured'), 
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
                    
//                     height: screenHeight * 0.3,
//                     width: screenWidth,
//                     child: FutureBuilder<List<DocumentSnapshot>>(
//                       future: firebaseService.getFeatured(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         } else if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                           return const Text('No data available');
//                         } else {
//                           return  NewCategoryTile(snapshotData: snapshot.data!, height: screenHeight/ 4 ,);
//                         }
//                       },
//                     ),
//                   ),
//                   ),
                   
                
//                   SizedBox(
                    
//                     height: screenHeight * 0.5 ,
//                     width: screenWidth,
//                     child: FutureBuilder<List<DocumentSnapshot>>(
//                       future: firebaseService.getrecentalyData(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         } else if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                           return const Text('No data available');
//                         } else {
//                           return const GridCategoryTile2(products: [],);
//                         }
//                       },
//                     ), 
//                   ),
//                  const SectionTitle(title: 'All products'),  
//                   SizedBox(
                      
//                       height: screenHeight * 0.7 ,  
//                       width: screenWidth,
//                       child: FutureBuilder<List<DocumentSnapshot>>(
//                         future: firebaseService.getProducts(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const CircularProgressIndicator();
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                             return const Text('No data available');
//                           } else {
//                             return GridCategoryTile(snapshotData: snapshot.data!);
//                           }
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({Key? key, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Text(
//         title,
        
//         style: const TextStyle(
        
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.black ,
          
//         ),
//       ),
//     ); 
//   } 
// }






// class NewCategoryTile extends StatefulWidget {
//   final List<DocumentSnapshot<Object?>> snapshotData;
//   final double height;
//    const NewCategoryTile({Key? key, required this.snapshotData,  required this.height}) : super(key: key);

//   @override
//   NewCategoryTileState createState() => NewCategoryTileState();
// }

// class NewCategoryTileState extends State<NewCategoryTile> {
  

//   int _currentPageIndex = 0;

//   void _navigateToProductDetails(DocumentSnapshot productSnapshot) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ProductDetailScreen(productSnapshot)),
//     );
//   }

  
// Widget buildImage(String imageUrl) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 8),
//     width: double.infinity,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: CachedNetworkImage(
//       placeholder: (context, url) =>
//           Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"), // Replace with your placeholder image
//       imageUrl: imageUrl,
//       fit: BoxFit.cover,
//     ),
//   );
// }

// @override
// Widget build(BuildContext context) {
//   return Column(
//     children: [
//       CarouselSlider.builder(
//         itemBuilder: (context, index, realIndex) {
//           DocumentSnapshot productSnapshot = widget.snapshotData[index];
//           List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

//           String imageUrl = 
//               imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0]  as String? ?? '' : '';

//           return GestureDetector(    
//             onTap: () => _navigateToProductDetails(productSnapshot),
//             child: buildImage(imageUrl),
//           );
//         },
//         itemCount: widget.snapshotData.length,
//         options: CarouselOptions(
//           onPageChanged: (index, reason) {
//             setState(() {
//               _currentPageIndex = index;
//             });
//           },
//           enlargeCenterPage: true,
//           padEnds: true,
//           viewportFraction: 0.98,
//           autoPlay: true,
//           height: widget.height,
//         ),
//       ),
//       const SizedBox(height: 10),
//       buildIndicator(),
//     ],
//   );
// }




//   Widget buildIndicator() {
//     return Center(
//       child: AnimatedSmoothIndicator(
//         activeIndex: _currentPageIndex,
//         count: widget.snapshotData.length,
//         effect:  const ExpandingDotsEffect(
//           dotColor: Color.fromRGBO(217, 217, 217, 1),
//           activeDotColor: Color.fromARGB(255, 59, 59, 59),
//           dotWidth: 10,
//           dotHeight: 7,
//         ),
//       ),
//     );
//   }
// }


 
// class GridCategoryTile extends StatelessWidget {
//   final List<DocumentSnapshot<Object?>> snapshotData;

//   const GridCategoryTile({Key? key, required this.snapshotData}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
    
//     final double sWidth = MediaQuery.of(context).size.width;
//     final double sHeight = MediaQuery.of(context).size.height;

//     return snapshotData.isNotEmpty
//         ? GridView.builder(
            
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.63,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: snapshotData.length,
//             itemBuilder: (BuildContext context, int index) {  
//               final productSnapshot = snapshotData[index];
        
//               String name = productSnapshot['name'] as String? ?? '';
//               double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
//               List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;
        
//               String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';
        
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 width: 200,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => ProductDetailScreen(productSnapshot),
//                         ));
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 5),
//                             width: sWidth / 2.2,
//                             height: sWidth / 2.2,
//                             alignment: Alignment.center,
//                             child: CachedNetworkImage(
//                               placeholder: (context, url) =>
//                                   Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"),
//                               imageUrl: imageUrl,
//                               imageBuilder: (context, imageProvider) => Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 10, right: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   name,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.poppins(
//                                     textStyle: const TextStyle(
//                                         fontSize: 18, fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "₹ $price",
//                                       style: GoogleFonts.inter(
//                                         textStyle: const TextStyle(
//                                             fontSize: 15, fontWeight: FontWeight.w500),
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     (productSnapshot["stock"]) > 0
//                                         ? const Text(
//                                             "In stock  ",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.green),
//                                           )
//                                         : const Text(
//                                             "out of stock  ",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.red),
//                                           )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                    const SizedBox(height: 20,), 
//                     SizedBox(
//                       width: 200,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 0, left: 10),
//                             height: sHeight / 30,
//                             width: sWidth / 4.5,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if ((productSnapshot["stock"]) > 0) {
                                   
                    
//                                     Navigator.push(
//                                   context,
//                                 MaterialPageRoute(
//                                    builder: (context) => Buy(
//                                                productSnapshot,
    
//                                              toggleFlagCallback: () {},
//                                                ),
//                                                 ),

//                                );
                   
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                       duration: const Duration(seconds: 1),
//                                       backgroundColor: Colors.red,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       content: const SizedBox(
//                                         height: 51,
//                                         child: Center(
//                                           child: Text("Out of stock ! ",
//                                               style: TextStyle(fontWeight: FontWeight.bold),
//                                               textAlign: TextAlign.center),
//                                         ),
//                                       )));
//                                 }
//                               },
                              
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
                              
//                               child: const Text(
//                                 "Buy",
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
                         
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           )
//         : SizedBox(
//             height: sHeight / 1.5,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   child: Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"),
//                 ),
//               ],
//             ),
//           );
//   }
  
  
// }





// class GridCategoryTile2 extends StatelessWidget {
//   final List<Product> products;

//   const GridCategoryTile2({Key? key, required this.products}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: products.map((product) {
//           return SizedBox(
//             width: MediaQuery.of(context).size.width / 2.5,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               color: Colors.white,
//               child: InkWell(
//                 onTap: () {
//                   // Handle product tap
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 8, bottom: 8),
//                       width: MediaQuery.of(context).size.width / 3.5,
//                       height: MediaQuery.of(context).size.height / 4.5,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         image: DecorationImage(
//                           image: NetworkImage(product.imageUrls[0]),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 200,
//                             height: 40,
//                             child: Text(
//                               product.name,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.roboto(
//                                 textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "MRP ₹ ${product.price}\n(Incl. of all taxes)",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.roboto(
//                               textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
