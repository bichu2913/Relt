// grid_category_tile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:relt/view/buy/buy.dart';
import 'package:relt/view/buy/buyview.dart';

class GridCategoryTile extends StatelessWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final Function(DocumentSnapshot) onTap;

  const GridCategoryTile({Key? key, required this.snapshotData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sWidth = MediaQuery.of(context).size.width;
    final double sHeight = MediaQuery.of(context).size.height;

    return snapshotData.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.63,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshotData.length,
            itemBuilder: (BuildContext context, int index) {
              final productSnapshot = snapshotData[index];

              String name = productSnapshot['name'] as String? ?? '';
              double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
              List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

              String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        onTap(productSnapshot);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: sWidth / 2.2,
                            height: sWidth / 2.2,
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"),
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹ $price",
                                      style: GoogleFonts.inter(
                                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Spacer(),
                                    (productSnapshot["stock"]) > 0
                                        ? const Text(
                                            "In stock  ",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                          )
                                        : const Text(
                                            "out of stock  ",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                          )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,), 
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 0, left: 10),
                            height: sHeight / 30,
                            width: sWidth / 4.5,
                            child: ElevatedButton(
                              
                              onPressed: () {
                                if ((productSnapshot["stock"]) > 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BuyPage(
                                        productSnapshot,
                                        // toggleFlagCallback: () {},
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    content: const SizedBox(
                                      height: 51,
                                      child: Center(
                                        child: Text("Out of stock ! ", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Buy",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        : SizedBox(
            height: sHeight / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"),
                ),
              ],
            ),
          );
  }
}
