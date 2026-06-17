import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/app_config.dart';

class ImageHelper {
  static Widget buildPlantImage({required String path, double? width, double? height}) {
    if (path.isEmpty) {
      return _buildStaticPlaceholder(width, height);
    }

    // 100% bête et discipliné : URL de base du AppConfig + ce que renvoie l'API, sans condition.
    final finalUrl = "${AppConfig.serverBaseUrl}/$path";

    return Image.network(
      finalUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,


      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 120), // Fondu ultra-rapide (divisé par 2) pour un effet nerveux et haut de gamme
          curve: Curves.easeOut,
          child: child,
        );
      },

      // Le chargement affiche directement ton placeholder texturé en arrière-plan
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return child;
      },

      // Si le serveur renvoie un lien mort ou une mauvaise IP : l'app n'essaye pas de réparer, elle bascule sur le placeholder.
      errorBuilder: (context, error, stackTrace) => _buildStaticPlaceholder(width, height),
    );
  }

  static Widget _buildStaticPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF2F1EC), // Ton ivoire/beige chic
      child: Center(
        child: Icon(
          Icons.insert_photo_outlined,
          color: Colors.grey.shade400,
          size: width != null && width < 100 ? 20 : 32,
        ),
      ),
    );
  }
}