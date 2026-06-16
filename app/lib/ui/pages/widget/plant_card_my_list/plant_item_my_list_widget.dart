import 'package:app/ui/pages/widget/tools/redirection_object_profile_details_page.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/object_profile.dart';
import 'package:app/app_config.dart';
import '../../bowl_detail_page.dart';
import '../../plant_detail_page.dart';
import '../tools/ui_utils.dart';

class PlantItemMyListWidget extends StatelessWidget {
  final ObjectProfile plant;

  const PlantItemMyListWidget({
    Key? key,
    required this.plant,
  }) : super(key: key);

  Color getStateColor(BuildContext context, int? state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state == 5) return colorScheme.error;
    if (state == 3 || state == 4) return Colors.orange.shade600;
    if (state == 1 || state == 2) return Colors.green.shade600;
    return colorScheme.outline;
  }

  String getStateLabel(BuildContext context, int? state) {
    final l10n = AppLocalizations.of(context)!;

    if (state == 5) return l10n.plantStatusDanger;
    if (state == 3 || state == 4) return l10n.plantStatusWarning;
    if (state == 1 || state == 2) return l10n.plantStatusHealthy;
    return l10n.plantStatusUnknown;
  }

  @override
  Widget build(BuildContext context) {
    final pathPicture = plant.pathPicture;
    final stateColor = getStateColor(context, plant.state);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // --- LOGIQUE DE REDIRECTION DYNAMIQUE ---
          RedirectionObjectProfileDetailsPage.navigateToDetail(
            context,
            plant.idCategoryTypeObject ?? 1,
            plant.idObjectProfile,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 75,
                    height: 75,
                    color: Colors.grey.shade200,
                    child: ImageHelper.buildPlantImage(
                      path: plant.pathPicture,
                      width: 75,
                      height: 75,
                    ),
                  ),
                ),

                const SizedBox(width: 18),

                // Texte + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.title ?? AppLocalizations.of(context)!.plantItemUnknownName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),

                      // Badge état
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: stateColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          getStateLabel(context, plant.state),
                          style: TextStyle(
                            color: stateColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}