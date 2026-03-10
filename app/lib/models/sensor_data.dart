class SensorData {
  final Map<String, double?> current;
  final Map<String, double?> averages;
  final Map<String, double?> targets;

  SensorData({required this.current, required this.averages, required this.targets});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    double? parse(dynamic v) => v == null ? null : double.tryParse(v.toString());

    // Sécurisation des accès aux clés du JSON
    Map<String, dynamic> currentRaw = json['current'] ?? {};
    Map<String, dynamic> averagesRaw = json['averages'] ?? {};
    Map<String, dynamic> targetsRaw = json['targets'] ?? {};

    return SensorData(
      current: {
        'temp': parse(currentRaw['temp']),
        'hum_air': parse(currentRaw['hum_air']),
        'hum_sol': parse(currentRaw['hum_sol']),
        'uv': parse(currentRaw['uv']),
        'fertility': parse(currentRaw['fertility']),
      },
      averages: {
        'temp': parse(averagesRaw['temp']),
        'hum_air': parse(averagesRaw['hum_air']),
        'hum_sol': parse(averagesRaw['hum_sol']),
        'uv': parse(averagesRaw['uv']),
        'fertility': parse(averagesRaw['fertility']),
      },
      targets: {
        'temp': parse(targetsRaw['temp']),
        'hum_air': parse(targetsRaw['hum_air']),
        'hum_sol': parse(targetsRaw['hum_sol']),
        'uv': parse(targetsRaw['uv']),
        'fertility': parse(targetsRaw['fertility']),
      },
    );
  }

  factory SensorData.empty() {
    return SensorData(current: {}, averages: {}, targets: {});
  }
}