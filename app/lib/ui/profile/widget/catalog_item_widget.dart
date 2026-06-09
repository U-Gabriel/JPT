import 'package:flutter/material.dart';
import '../../../models/category_catalog.dart';
import '../../pages/widget/tools/redirection_object_profile_details_page.dart';
import '../../pages/widget/tools/ui_utils.dart';

class CatalogItemWidget extends StatelessWidget {
  final CatalogObject item;
  final VoidCallback? onTapRefresh; // 🌟 Nouvelle fonction optionnelle de refresh

  const CatalogItemWidget({
    Key? key,
    required this.item,
    this.onTapRefresh, // Ajouté ici
  }) : super(key: key);

  Color getStateColor(int state) {
    if (state == 5) return const Color(0xFFE53935);
    if (state == 3 || state == 4) return const Color(0xFFFFA000);
    if (state == 1 || state == 2) return const Color(0xFF43A047);
    return const Color(0xFF9E9E9E);
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = getStateColor(item.statePlant);

    return InkWell(
      onTap: () {
        // --- 🛠️ NAVIGATION CENTRALISÉE AVEC DETECTION DE RETOUR ---
        RedirectionObjectProfileDetailsPage.navigateToDetail(
          context,
          item.idCategoryType,
          item.idObjectProfile,
          onReturn: onTapRefresh, // On passe le refresh au routeur
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: ImageHelper.buildPlantImage(
                    path: item.pathPicture,
                    height: 110,
                    width: 150,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: stateColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}