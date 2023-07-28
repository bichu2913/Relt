class Order {
  final String productId;
  final String selectedSize;
  final int quantity;
  final double total;
  final double price;
  final Map<String, dynamic> selectedAddress;
  final String status;

  Order({
    required this.productId,
    required this.selectedSize,
    required this.quantity,
    required this.total,
    required this.price,
    required this.selectedAddress,
    required this.status,
  });
}
