
class ProductData {
  final String productId;
  final String productName;
  final int quantity;
  final String size;
  final double total;
  final String status;

  ProductData({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.size,
    required this.total,
    required this.status,
  });

  factory ProductData.fromMap(Map<String, dynamic> map) {
    return ProductData(
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      size: map['selectedSize'],
      total: map['total'],
      status: map['status'],
    );
  }
}

class OrderData {
  final List<ProductData> products;

  OrderData({
    required this.products,
  });
}





