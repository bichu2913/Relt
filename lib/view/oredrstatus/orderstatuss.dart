// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:relt/controller/order_status.dart';
// import 'package:relt/firebase/firebasedata.dart';

// class OrderStatusView extends StatefulWidget {
//   const OrderStatusView({Key? key}) : super(key: key);

//   @override
//   State<OrderStatusView> createState() => _OrderStatusViewState();
// }

// class _OrderStatusViewState extends State<OrderStatusView> {
//   bool isDataLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Status'),
//       ),
//       body:FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         future: FirebaseService().getOrderData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasData) {
//             final OrderData orderData = snapshot.data!;

//             return OrderStatusListView(orderData: orderData);
//           }

//           return const Center(
//             child: Text('Failed to fetch order data.'),
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderStatusListView extends StatelessWidget {
//   final OrderData orderData;

//   const OrderStatusListView({required this.orderData, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               'Order Status',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (orderData.products.isNotEmpty)
//               Column(
//                 children: orderData.products.map((product) {
//                   return ProductItemView(
//                     product: product,
//                     onUpdateStatus: (newStatus) {
//                       FirebaseService().updateProductStatus(
//                         product.productId,
//                         newStatus,
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//             ElevatedButton(
//               onPressed: () {
//                 // Add any necessary navigation logic here
//               },
//               child: const Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductItemView extends StatelessWidget {
//   final ProductData product;
//   final void Function(String) onUpdateStatus;

//   const ProductItemView({
//     required this.product,
//     required this.onUpdateStatus,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 343,
//       height: 164,
//       child: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               width: 343,
//               height: 164,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color.fromRGBO(0, 0, 0, 0.12),
//                     offset: Offset(0, 1),
//                     blurRadius: 24,
//                   ),
//                 ],
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 118,
//             left: 254,
//             child: Text(
//               product.status,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Color.fromRGBO(42, 169, 82, 1),
//                 fontFamily: 'Roboto',
//                 fontSize: 14,
//                 letterSpacing: 0,
//                 fontWeight: FontWeight.normal,
//                 height: 1.4285714285714286,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 18,
//             left: 28,
//             child: Text(
//               product.productName,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Color.fromRGBO(34, 34, 34, 1),
//                 fontFamily: 'Roboto',
//                 fontSize: 16,
//                 letterSpacing: 0,
//                 fontWeight: FontWeight.normal,
//                 height: 1,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 74,
//             left: 25,
//             child: SizedBox(
//               width: 77,
//               height: 20,
//               child: Stack(
//                 children: [
//                   const Positioned(
//                     top: 0,
//                     left: 0,
//                     child: Text(
//                       'Quantity:',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         color: Color.fromRGBO(155, 155, 155, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1.4285714285714286,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 3,
//                     left: 60,
//                     child: Text(
//                       '${product.quantity}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Color.fromRGBO(34, 34, 34, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 16,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             left: 28,
//             child: SizedBox(
//               width: 214,
//               height: 20,
//               child: Stack(
//                 children: [
//                   const Positioned(
//                     top: 0,
//                     left: 0,
//                     child: Text(
//                       'Size:',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         color: Color.fromRGBO(155, 155, 155, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1.4285714285714286,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 40,
//                     child: Text(
//                       product.size,
//                       textAlign: TextAlign.left,
//                       style: const TextStyle(
//                         color: Color.fromRGBO(34, 34, 34, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1.4285714285714286,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 74,
//             left: 186,
//             child: SizedBox(
//               width: 133,
//               height: 20,
//               child: Stack(
//                 children: [
//                   const Positioned(
//                     top: 0,
//                     left: 0,
//                     child: Text(
//                       'Total Amount:',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         color: Color.fromRGBO(155, 155, 155, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1.4285714285714286,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 3,
//                     left: 92,
//                     child: Text(
//                       '\$${product.total}',
//                       textAlign: TextAlign.left,
//                       style: const TextStyle(
//                         color: Color.fromRGBO(34, 34, 34, 1),
//                         fontFamily: 'Roboto',
//                         fontSize: 16,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.normal,
//                         height: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 18,
//             left: 254,
//             child: PopupMenuButton(
//               icon: const Icon(Icons.more_vert),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   child: ListTile(
//                     leading: const Icon(
//                       Icons.cancel_outlined,
//                       color: Colors.grey,
//                     ),
//                     title: const Text('cancel'),
//                     onTap: () {
//                       onUpdateStatus('Cancelled');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

