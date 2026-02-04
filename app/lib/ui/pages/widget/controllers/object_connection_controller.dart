import 'package:flutter/material.dart';
import 'package:app/services/object_profile_service.dart';
import 'package:app/ui/pages/widget/popup/connection_error_dialog.dart';

class ObjectConnectionController {
  final ObjectProfileService apiService = ObjectProfileService();

  Future<int?> createProfile({
    required BuildContext context,
    required String title,
    required int idObject,
    required int idPlantType,
    required int idPerson,
    required String token,
  }) async {
    try {
      return await apiService.createObjectProfileShort(
        title: title,
        idObject: idObject,
        idPlantType: idPlantType,
        idPerson: idPerson,
        token: token,
      );
    } catch (e) {
      // On gère la pop-up directement ici ou on relance l'erreur ?
      // Pour rester "pro", on demande à l'UI via un callback ou on utilise le contexte prudemment.
      if (!context.mounted) return null;

      bool? retry = await ConnectionErrorDialog.show(
        context,
        title: "Erreur API",
        message: "Impossible de créer l'objet, vérifiez votre connexion internet.",
      );

      if (retry == true) {
        // Récursion : on réessaye
        return await createProfile(
          context: context,
          title: title,
          idObject: idObject,
          idPlantType: idPlantType,
          idPerson: idPerson,
          token: token,
        );
      } else {
        // L'utilisateur annule
        Navigator.of(context).pop();
        return null;
      }
    }
  }
}