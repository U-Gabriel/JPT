import 'package:flutter/material.dart';
import '../../../../models/object_profile.dart';
import 'package:app/app_config.dart';
import '../../plant_detail_page.dart';

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

  String getStateLabel(int? state) {
    if (state == 5) return "En danger";
    if (state == 3 || state == 4) return "À surveiller";
    if (state == 1 || state == 2) return "En bonne santé";
    return "Inconnu";
  }

  @override
  Widget build(BuildContext context) {
    final pathPicture = plant.plantType.pathPicture;
    final stateColor = getStateColor(context, plant.state);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PlantDetailPage(plantId: plant.idObjectProfile),
            ),
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
                    child: pathPicture != null
                        ? Image.network(
                      Uri.parse(AppConfig.baseUrlDataset)
                          .resolve(pathPicture)
                          .toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                    )
                        : const Icon(Icons.image_not_supported),
                  ),
                ),

                const SizedBox(width: 18),

                // Texte + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.title ?? "Nom inconnu",
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
                          getStateLabel(plant.state),
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