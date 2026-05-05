class CartItem {
  final int idCartItem;
  final int id;
  final String title;
  final String description;
  final double price;
  final double? discountPrice;
  final int stock;
  final String? image;
  int quantity;
  bool isSelected;

  CartItem({
    required this.idCartItem,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.image,
    this.quantity = 1,
    this.isSelected = true,
  });

  bool get isStockIssue => quantity > stock;
  double get effectivePrice => (discountPrice != null && discountPrice! > 0) ? discountPrice! : price;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idCartItem: json['id_cart_item'] ?? 0,
      id: json['id_object'] ?? 0,
      title: json['title'] ?? "Produit inconnu",
      description: json['description'] ?? "",
      price: double.tryParse(json['price']?.toString() ?? "0") ?? 0.0,
      discountPrice: double.tryParse(json['discount_price']?.toString() ?? "0"),
      stock: json['stock_quantity'] ?? 0,
      image: json['main_picture'],
      quantity: json['cart_quantity'] ?? 1,
    );
  }
}