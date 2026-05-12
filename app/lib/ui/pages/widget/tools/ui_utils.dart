import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/app_config.dart';

class ImageHelper {
  /// Widget universel pour afficher une image de plante ou le pot par défaut
  static Widget buildPlantImage({
    required String path,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path.trim().isEmpty) {
      return _buildPlaceholder(width, height);
    }

    try {
      final baseUrl = AppConfig.baseUrlDataset;
      final fullUrl = Uri.parse(baseUrl).resolve(path).toString();

      return Image.network(
        fullUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(width, height),
        // Petit indicateur de chargement discret
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF0EEE9),
            child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
          );
        },
      );
    } catch (e) {
      return _buildPlaceholder(width, height);
    }
  }

  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0EEE9),
      child: Center(
        child: SvgPicture.asset(
          'assets/move/move_pot.svg',
          // On ajuste la taille du SVG proportionnellement à la zone
          height: (height != null) ? height * 0.5 : 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}