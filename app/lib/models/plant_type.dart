import 'avatar.dart';

class PlantType {
  final int? idPlantType;
  final String title;
  final String? description;
  final String? advise;
  final String? scientistName;
  final String? familyName;
  final String? typeName;
  final String? expositionType;
  final String? groundType;
  final double? phGroundSensor;
  final double? conductivityElectriqueFertilitySensor;
  final double? lightSensor;
  final double? temperatureSensorGround;
  final double? temperatureSensorExtern;
  final double? humidityAirSensor;
  final double? humidityGroundSensor;
  final String? pathPicture;
  final String? height;
  final String? category;
  final String? plantationSaison;
  final String? saisonFirst;
  final String? saisonSecond;
  final String? saisonThird;
  final String? saisonLast;
  final double? expositionTimeSun;
  final List<Avatar>? avatars;


  PlantType({
    required this.idPlantType,
    required this.title,
    this.description,
    this.advise,
    this.scientistName,
    this.familyName,
    this.typeName,
    this.expositionType,
    this.groundType,
    this.phGroundSensor,
    this.conductivityElectriqueFertilitySensor,
    this.lightSensor,
    this.temperatureSensorGround,
    this.temperatureSensorExtern,
    this.humidityAirSensor,
    this.humidityGroundSensor,
    this.pathPicture,
    this.height,
    this.category,
    this.plantationSaison,
    this.saisonFirst,
    this.saisonSecond,
    this.saisonThird,
    this.saisonLast,
    this.expositionTimeSun,
    this.avatars,
  });


  factory PlantType.fromJson(Map<String, dynamic> json) => PlantType(
    idPlantType: json['id_plant_type'] ?? 0,
    title: json['title'],
    description: json['description'],
    advise: json['advise'],
    scientistName: json['scientist_name'],
    familyName: json['family_name'],
    typeName: json['type_name'],
    expositionType: json['exposition_type'],
    groundType: json['ground_type'],
    phGroundSensor: double.tryParse(json['phGroundSensor'] ?? ''),
    conductivityElectriqueFertilitySensor:
    double.tryParse(json['conductivityElectriqueFertilitySensor'] ?? ''),
    lightSensor: double.tryParse(json['lightSensor'] ?? ''),
    temperatureSensorGround: double.tryParse(json['temperatureSensorGround'] ?? ''),
    temperatureSensorExtern: double.tryParse(json['temperatureSensorExtern'] ?? ''),
    humidityAirSensor: double.tryParse(json['humidityAirSensor'] ?? ''),
    humidityGroundSensor: double.tryParse(json['humidityGroundSensor'] ?? ''),
    pathPicture: json['picture_path'] ?? json['path_picture'],
    height: json['height'],
    category: json['category'],
    plantationSaison: json['plantation_saison'],
    saisonFirst: json['saison_first'],
    saisonSecond: json['saison_second'],
    saisonThird: json['saison_third'],
    saisonLast: json['saison_last'],
    expositionTimeSun: double.tryParse(json['exposition_time_sun']?.toString() ?? ''),
    avatars: (json['avatars'] as List? ?? [])
        .map((item) => Avatar.fromJson(item))
        .toList(),
  );


  factory PlantType.defaultType() {
    return PlantType(
      idPlantType: 0,
      title: "Plante inconnue",
      description: "Pas de description",
      pathPicture: null,
    );
  }
}
