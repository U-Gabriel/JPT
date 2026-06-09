import 'object_profile.dart';

class CategoryCatalog {
  final int idCategoryType;
  final String categoryTitle;
  final List<CatalogObject> objects;

  CategoryCatalog({
    required this.idCategoryType,
    required this.categoryTitle,
    required this.objects,
  });

  factory CategoryCatalog.fromJson(Map<String, dynamic> json) {
    var list = json['objects'] as List? ?? [];
    List<CatalogObject> objectList = list.map((i) => CatalogObject.fromJson(i, json['id_category_type'])).toList();

    return CategoryCatalog(
      idCategoryType: parseInt(json['id_category_type']) ?? 0,
      categoryTitle: json['category_title'] ?? '',
      objects: objectList,
    );
  }
}

class CatalogObject {
  final int idObjectProfile;
  final int idCategoryType; // On l'injecte depuis le parent pour la redirection
  final String title;
  final int statePlant;
  final String pathPicture;

  CatalogObject({
    required this.idObjectProfile,
    required this.idCategoryType,
    required this.title,
    required this.statePlant,
    required this.pathPicture,
  });

  factory CatalogObject.fromJson(Map<String, dynamic> json, int categoryId) {
    return CatalogObject(
      idObjectProfile: parseInt(json['id_object_profile']) ?? 0,
      idCategoryType: categoryId,
      title: json['title'] ?? '',
      statePlant: parseInt(json['state_plant']) ?? 1,
      pathPicture: json['path_picture'] ?? '',
    );
  }
}