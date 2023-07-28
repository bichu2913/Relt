
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relt/controller/cart_page.dart';
import 'package:relt/view/bottom_navigation/buttomnavigation.dart';
import 'package:relt/view/buy/buyview.dart';
import 'package:relt/view/home_page/widgets/name_tile.dart';
import '../firebase/firebasedata.dart';

 
class ProductDetailScreen extends StatefulWidget {
  final DocumentSnapshot productSnapshot; 

   ProductDetailScreen(this.productSnapshot, {Key? key}) : super(key: key);
  final FirebaseService firebaseService = FirebaseService();
  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}  
 
class ProductDetailScreenState extends State<ProductDetailScreen> {
   
  

void navigateToBuy(DocumentSnapshot productSnapshot) {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) =>BuyPage(  productSnapshot,   )),
    
  );
}
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar:  AppBar(title: const Text("PRODUCT DETAILS ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: Column( 
        children: [
           const SizedBox(height: 16),
               Images(onTap: (p0) { }, 
                  snapshotData: [widget.productSnapshot],height: MediaQuery.of(context).size.height / 3,
                ), 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Text( 
                    (widget.productSnapshot['name'] as String?) ?? '',
                    style: GoogleFonts.roboto(  
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23, 
                        ), 
                      ),
                  ),
                ),
                
                Text( 
                  ' ₹ ${(widget.productSnapshot['price'] as num?)?.toStringAsFixed(2) ?? ''}',
                  style:GoogleFonts.sora(
                      height: 1.5,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20, 
                      ),
                    ),
                ),
                  (widget.productSnapshot["stock"]) > 0
                      ? (widget.productSnapshot["stock"]) < 5
                          ? Text(
                              "Hurry only ${widget.productSnapshot["stock"]} left !  ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,fontSize: 20),
                            )
                          : const Text(
                              "  In stock  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,fontSize: 20),
                            )
                      : const Text(
                          " out of stock  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red,fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                       Text(
                     " Description",
                 style: GoogleFonts.sora(
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
                      ),
                      const SizedBox(height: 8),
                Container(decoration: BoxDecoration(
                    color:const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(10), 
        ),
                  child: TextFormField(
    controller: TextEditingController(text: 
                    ' ${widget.productSnapshot['description'] as String? ?? ''}',
                   
                  ),
    minLines: 1,
    readOnly:true,
     maxLines:  50,
    textAlignVertical: TextAlignVertical.center,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      border: InputBorder.none,
      hintStyle: GoogleFonts.inter(
          textStyle: const TextStyle(color: Color.fromARGB(255, 80, 80, 80))),
    ),
  ),
                ),
                const SizedBox(height: 16),
                


                
               
              ],
              
            ),
          ),
           customBottomBar() 
        ],
      ),
    );
  }

Container customBottomBar() { 
  return Container(
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    height: MediaQuery.of(context).size.height / 10,
    child: Column(
      children: [
        const SizedBox(height: 20),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 2.5,
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 22,
              ),
              child: TextButton(
                onPressed: () async {
                  if ((widget.productSnapshot["stock"]) > 0) {}
                  if (await CartManager().isProductInCart(widget.productSnapshot)) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(microseconds: 800),
                        backgroundColor: Colors.white,
                        content: Text(
                          "Product is already in the cart",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationScreen(),
                      ),
                    );
                  } else {
                    if ((widget.productSnapshot["stock"]) > 0) {
                      await CartManager().toggleCartStatus(widget.productSnapshot, true);
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      // ignore: use_build_context_synchronously
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
                                "Product is out of stock ! ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
                child:FutureBuilder<bool>(
  future: CartManager().isProductInCart(widget.productSnapshot),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // or any other loading indicator
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      bool isInCart = snapshot.data ?? false;
      return GestureDetector(onTap: () {
         CartManager cartManager = CartManager();
                        cartManager.toggleCartStatus(widget.productSnapshot, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added to cart')),
                        );
      },
        child: Text(
          isInCart ? 'already in cart ' : 'Add to cart', 
          style: GoogleFonts.sora( 
                      textStyle: const TextStyle( 
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        ),
      );
    }
  },
),

              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 2.5,
              // ignore: sort_child_properties_last
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  await CartManager().toggleCartStatus(widget.productSnapshot, true);
                 
                  if ((widget.productSnapshot["stock"]) > 0) {
                    
                   navigateToBuy(widget.productSnapshot);
                  } else {
                    // ignore: use_build_context_synchronously
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
                              "Product is out of stock ! ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "Buy now",
                  style: GoogleFonts.sora(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 22,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}
