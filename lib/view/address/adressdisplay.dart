import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressList extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');
  final String userId;
  final Null Function() toggleFlagCallback;
  final Null Function(dynamic selectedAddressIndex) onAddressSelected;
  final int selectedAddressIndex;

  AddressList({
    required this.userId,
    required this.toggleFlagCallback,
    required this.onAddressSelected,
    required this.selectedAddressIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: usersCollection.doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
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

        return Column(
          children: List.generate(addresses.length, (index) {
            Map<String, dynamic> address = addresses[index] as Map<String, dynamic>;

            return RadioListTile(
              title: Text(address['address'] as String),
              subtitle: Text('${address['city']}, ${address['phone']}'),
              value: index,
              groupValue: selectedAddressIndex,
              onChanged: (value) {
                onAddressSelected(value as int);
              },
            );
          }),
        );
      },
    );
  }
}



