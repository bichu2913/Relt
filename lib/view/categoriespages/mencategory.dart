

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/view/categoriespages/categoriestile.dart';
import 'package:relt/firebase/firebasedata.dart';

class MenNewPage extends StatelessWidget {
 final FirebaseService firebaseService = FirebaseService();

  MenNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" new  ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getMenProducts(),    
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
 

class MenShirtsPage extends StatelessWidget {
   final FirebaseService firebaseService = FirebaseService();

  MenShirtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SHIRT ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getMenShirts(),
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

class MenPantsPage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  MenPantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PANTS ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getMenPants(),
        
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

class MenAccessoriesPage extends StatefulWidget {
  

  const MenAccessoriesPage({super.key});

  @override
  State<MenAccessoriesPage> createState() => _MenAccessoriesPageState();
  
}

class _MenAccessoriesPageState extends State<MenAccessoriesPage> {
 final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(title: const Text("ACCESORIES ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: firebaseService.getMenAccessories(),
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







