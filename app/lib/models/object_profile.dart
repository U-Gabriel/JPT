import 'object_model.dart';
import 'plant_type.dart';

class ObjectProfile {
  final int idObjectProfile;
  final String title;
  final String description;
  final String? advise;
  final String? recipe;
  final int? state;
  final bool? isAutomatic;
  final bool? isWillWatering;
  final ObjectModel? object;
  final PlantType plantType;
  final double? humidityAirSensor;
  final double? humidityGroundSensor;
  final double? phGroundSensor;
  final double? conductivityElectriqueFertilitySensor;
  final bool? lightSensor;
  final double? temperatureSensorGround;
  final double? temperatureSensorExtern;
  final double? expositionTimeSun;

  ObjectProfile({
    required this.idObjectProfile,
    required this.title,
    required this.description,
    this.advise,
    this.recipe,
    this.state,
    this.isAutomatic,
    this.isWillWatering,
    required this.object,
    required this.plantType,
    this.humidityAirSensor,
    this.humidityGroundSensor,
    this.phGroundSensor,
    this.conductivityElectriqueFertilitySensor,
    this.lightSensor,
    this.temperatureSensorGround,
    this.temperatureSensorExtern,
    this.expositionTimeSun,
  });

  factory ObjectProfile.fromJson(Map<String, dynamic> json) {
    try {
      return ObjectProfile(
        idObjectProfile: parseInt(json['id_object_profile']) ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        advise: json['advise'],
        recipe: json['recipe'], //A voir
        state: parseInt(json['state']),
        isAutomatic: json['is_automatic'],
        isWillWatering: json['is_water'],
        object: json['object'] != null ? ObjectModel.fromJson(json['object']) : null,
        plantType: PlantType.fromJson(json['plant_type']),
        humidityAirSensor: parseDouble(json['humidity_air_sensor']),
        humidityGroundSensor: parseDouble(json['humidity_ground_sensor']),
        phGroundSensor: parseDouble(json['ph_ground_sensor']),
        conductivityElectriqueFertilitySensor: parseDouble(json['conductivity_elec_sensor']),
        lightSensor: json['is_light'],
        temperatureSensorGround: parseDouble(json['temperature_ground_sensor']),
        temperatureSensorExtern: parseDouble(json['temperature_air_sensor']),
        expositionTimeSun: parseDouble(json['exposition_time_sun']),
      );
    } catch (e, stack) {
      print("Erreur de parsing ObjectProfile: $e");
      print(stack);
      rethrow;
    }
  }

  ObjectProfile copyWith({
    int? idObjectProfile,
    String? title,
    String? description,
    String? advise,
    String? recipe,
    int? state,
    bool? isAutomatic,
    bool? isWillWatering,
    ObjectModel? object,
    PlantType? plantType,
    double? humidityAirSensor,
    double? humidityGroundSensor,
    double? phGroundSensor,
    double? conductivityElectriqueFertilitySensor,
    bool? lightSensor,
    double? temperatureSensorGround,
    double? temperatureSensorExtern,
    double? expositionTimeSun,
  }) {
    return ObjectProfile(
      idObjectProfile: idObjectProfile ?? this.idObjectProfile,
      title: title ?? this.title,
      description: description ?? this.description,
      advise: advise ?? this.advise,
      recipe: recipe ?? this.recipe,
      state: state ?? this.state,
      isAutomatic: isAutomatic ?? this.isAutomatic,
      isWillWatering: isWillWatering ?? this.isWillWatering,
      object: object ?? this.object,
      plantType: plantType ?? this.plantType,
      humidityAirSensor: humidityAirSensor ?? this.humidityAirSensor,
      humidityGroundSensor: humidityGroundSensor ?? this.humidityGroundSensor,
      phGroundSensor: phGroundSensor ?? this.phGroundSensor,
      conductivityElectriqueFertilitySensor: conductivityElectriqueFertilitySensor ?? this.conductivityElectriqueFertilitySensor,
      lightSensor: lightSensor ?? this.lightSensor,
      temperatureSensorGround: temperatureSensorGround ?? this.temperatureSensorGround,
      temperatureSensorExtern: temperatureSensorExtern ?? this.temperatureSensorExtern,
      expositionTimeSun: expositionTimeSun ?? this.expositionTimeSun,
    );
  }
}

// Texte lisible pour les états
String getStateText(int? state) {
  switch (state) {
    case 0: return "Parfait pour moi";
    case 1: return "Je vais très bien";
    case 2: return "Je vais bien";
    case 3: return "Je suis ok";
    case 4: return "Je me sens moyen";
    case 5: return "Critique ! URGENT !";
    default: return "État inconnu";
  }
}

// Parse dynamique d'entiers (string/int)
int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

// Parse dynamique de doubles (int/string/double)
double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
