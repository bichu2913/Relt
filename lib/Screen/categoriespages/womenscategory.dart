
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/categoriespages/categoriestile.dart';

import 'package:relt/firebase/firebasedata.dart';

class WomenNewPage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  WomenNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women New Page'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getWomenProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            return Categorytile(snapshot);
          }
        },
      ),
    );
  }
}





class WomenTopsPage extends StatelessWidget {
  
   final FirebaseService firebaseService = FirebaseService();

  WomenTopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women Tops Page'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getWomenTops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            return Categorytile(snapshot);
          }
        },
      ),
    );
  }
}

class WomenPantsPage extends StatelessWidget {
    final FirebaseService firebaseService = FirebaseService();

  WomenPantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women pants Page'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getWomenPants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            return Categorytile(snapshot);
          }
        },
      ),
    );
  }
}

class WomenAccessoriesPage extends StatelessWidget {

    final FirebaseService firebaseService = FirebaseService();

  WomenAccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women Accesories Page'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getWomenAccessories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            return Categorytile(snapshot);
          }
        },
      ),
    );
  }
}
