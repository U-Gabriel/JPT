class Product {
  final int id;
  final String title;
  final String? shortDescription;
  final String description;
  final List<String> features;
  final List<String> technicalDetails;
  final String warranty;
  final double price;
  final double? discountPrice;
  final int stock;
  final String? brand;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    this.shortDescription,
    required this.description,
    required this.features,
    required this.technicalDetails,
    required this.warranty,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.brand,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_object'],
      title: json['title'] ?? "",
      shortDescription: json['short_description'],
      description: json['description'] ?? "",
      features: (json['features'] as String? ?? "").split(';').where((s) => s.isNotEmpty).toList(),
      technicalDetails: (json['technical_details'] as String? ?? "").split(';').where((s) => s.isNotEmpty).toList(),
      warranty: json['warranty_info'] ?? "Garantie standard",
      price: double.tryParse(json['price']?.toString() ?? "0") ?? 0,
      discountPrice: double.tryParse(json['discount_price']?.toString() ?? "0"),
      stock: json['stock_quantity'] ?? 0,
      brand: json['brand'] ?? "GDOME",
      images: (json['assets'] as List? ?? [])
          .map((a) => "http://51.77.141.175:3000/${a['file_path']}")
          .toList(),
    );
  }
}