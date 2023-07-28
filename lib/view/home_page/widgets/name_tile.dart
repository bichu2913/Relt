// section_title.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}


class Images extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final double height;
  final Function(DocumentSnapshot) onTap;

  const Images({
    Key? key,
    required this.snapshotData,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemBuilder: (context, index, realIndex) {
            DocumentSnapshot productSnapshot = widget.snapshotData[index];
            List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

            if (imageUrls == null || imageUrls.isEmpty) {
              return Container(); // Return an empty container if no images are available
            }

            return GestureDetector(
              onTap: () => widget.onTap(productSnapshot),
              child: buildImageSlider(imageUrls),
            );
          },
          itemCount: widget.snapshotData.length,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            enlargeCenterPage: true,
            padEnds: true,
            viewportFraction: 0.98,
            autoPlay: true,
            height: widget.height,
          ),
        ),
        const SizedBox(height: 10),
        buildIndicator(),
      ],
    );
  }

  Widget buildImageSlider(List<dynamic> imageUrls) {
    return CarouselSlider(
      items: imageUrls
          .map((imageUrl) => buildImage(imageUrl as String))
          .toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(
          "C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png", 
          fit: BoxFit.cover,
        ),
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: _currentPageIndex,
        count: widget.snapshotData.length,
        effect: const ExpandingDotsEffect(
          dotColor: Color.fromRGBO(217, 217, 217, 1),
          activeDotColor: Color.fromARGB(255, 59, 59, 59),
          dotWidth: 10,
          dotHeight: 7,
        ),
      ),
    );
  }
}

