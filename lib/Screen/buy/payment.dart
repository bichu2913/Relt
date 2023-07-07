import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



class Payment extends StatefulWidget {
  final double totalPrice;
  final VoidCallback toggleFlagCallback;

  
  const Payment({super.key, required this.totalPrice, required this.toggleFlagCallback, });

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _startPayment();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
   
  }
 
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success event\
    widget.toggleFlagCallback();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Payment ID: ${response.paymentId}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              
              },
              child: const Text('OK'),
              
            ),
            
          ],
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure event
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Text('Error Message: ${response.message}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet event
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('External Wallet'),
          content: Text('Wallet Name: ${response.walletName}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

 void _startPayment() {
  // Convert totalPrice from dollars to paise
  int amountInPaise = (widget.totalPrice * 100).toInt();

  var options = {
    'key': 'rzp_test_uq1CtGED5tI0GK',
    'amount': amountInPaise,
    'name': 'Relt',
    'description': 'Test Payment',
    'prefill': {
      'contact': '8606892913',
      'email': 'bichuamz@gmail.com',
    }
  };

  _razorpay.open(options);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('payment'),
      ),
      body: const Center(child: Text("please wait")),
     
    ); 
  }
}

