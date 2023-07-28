// grid_category_tile_2.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridCategoryTile2 extends StatelessWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final Function(DocumentSnapshot<Object?>) onTap;

  const GridCategoryTile2({Key? key, required this.snapshotData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: snapshotData.map((productSnapshot) {
          String name = productSnapshot['name'] as String? ?? '';
          double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
          List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

          String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

          return SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: InkWell(
                onTap: () => onTap(productSnapshot),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 4.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),  
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "MRP ₹ $price\n(Incl. of all taxes)",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

