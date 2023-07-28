import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relt/view/address/adressdisplay.dart';


class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  AddAddressPageState createState() => AddAddressPageState();
}

class AddAddressPageState extends State<AddAddressPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController(); 
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose(); 
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
void _saveAddress() async {
  // Perform validation and save the address to the database or appropriate storage

  // Example validation: Check if any field is empty
  if (_addressController.text.isEmpty ||
      _cityController.text.isEmpty ||
      _postalCodeController.text.isEmpty ||
      _phoneController.text.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: const Text('Please fill in all the fields.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else {
    try {
      String? userId = user.email;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await usersCollection.doc(userId).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (userSnapshot.exists) {
         List<Map<String, dynamic>> addresses = List<Map<String, dynamic>>.from(userSnapshot.data()?['addresses'] ?? []);

        addresses.add({
          'address': _addressController.text,
          'city': _cityController.text,
          'postalCode': _postalCodeController.text,
          'phone': _phoneController.text,
        });

        await usersCollection.doc(userId).update({
          'addresses': addresses,
        });
      } else {
        await usersCollection.doc(userId).set({
          'addresses': [
            {
              'address': _addressController.text,
              'city': _cityController.text,
              'postalCode': _postalCodeController.text,
              'phone': _phoneController.text,
            }
          ],
        });
      }

      // Address is saved successfully, perform any other necessary actions

      // For example, you can navigate back to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      [];
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone no',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveAddress,
              child: const Text('Save Address'),
            ),
            const Text(
              'Addresses:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold, 
              ),
            ),

            const SizedBox(height: 8.0),

            Expanded(
              child: AddressList(userId: user.email as String, onAddressSelected: (selectedAddressIndex) {  }, toggleFlagCallback: () {  }, selectedAddressIndex: -1, key: UniqueKey(), ),
            ),
          ],
        ),
      ),
    );
  }
}





