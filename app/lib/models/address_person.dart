class AddressPerson {
  final int? idAddress;
  final String title;
  final String addressLine1;
  final String addressLine2;
  final String postalCode;
  final String city;
  final String country;
  final bool isDefault;

  AddressPerson({
    this.idAddress,
    required this.title,
    required this.addressLine1,
    required this.addressLine2,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.isDefault,
  });

  factory AddressPerson.fromJson(Map<String, dynamic> json) {
    return AddressPerson(
      idAddress: json['id_address'],
      title: json['title'] ?? "",
      addressLine1: json['address_line1'] ?? "",
      addressLine2: json['address_line2'] ?? "",
      postalCode: json['postal_code'] ?? "",
      city: json['city'] ?? "",
      country: json['country'] ?? "France",
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "postal_code": postalCode,
    "city": city,
    "country": country,
    "is_default": isDefault,
  };
}