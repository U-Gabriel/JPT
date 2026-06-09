import 'package:flutter/material.dart';
import '../../bowl_detail_page.dart';
import '../../plant_detail_page.dart';

class RedirectionObjectProfileDetailsPage {
  /// Redirige dynamiquement vers la bonne page de détails selon la catégorie
  /// Le paramètre optionnel [onReturn] s'exécute automatiquement lors du retour arrière.
  static Future<void> navigateToDetail(
      BuildContext context,
      int categoryId,
      int objectProfileId, {
        VoidCallback? onReturn,
      }) async {

    // On attend que la page ouverte soit fermée ("pop")
    if (categoryId == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BowlDetailPage(
            objectProfileId: objectProfileId,
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailPage(
            plantId: objectProfileId,
          ),
        ),
      );
    }

    // Une fois revenu sur la page appelante, si un callback est fourni, on l'exécute
    if (onReturn != null) {
      onReturn();
    }
  }
}