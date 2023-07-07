import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddressList extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');
  final String userId;

  AddressList({required this.userId, });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: usersCollection.doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No addresses found.');
        }

        Map<String, dynamic>? userData = snapshot.data?.data();
        List<dynamic> addresses =
            (userData?['addresses'] ?? []) as List<dynamic>;

        if (addresses.isEmpty) {
          return const Text('No addresses found.');
        }

        return ListView.builder(
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> address = addresses[index] as Map<String, dynamic>;

            return ListTile(
              title: Text(address['address'] as String),
              subtitle: Text('${address['city']}, ${address['phone']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Implement address deletion functionality
                },
              ),
            );
          },
        );
      },
    );
  }
}
