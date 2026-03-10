import 'package:app/ui/pages/widget/plant_card_favorite/plant_control_switches_widget.dart';
import 'package:flutter/material.dart';
import '../../../../models/object_profile.dart';
import 'package:app/app_config.dart';

import '../../plant_detail_page.dart';

class PlantItemWidget extends StatelessWidget {
  final ObjectProfile plant;
  final Function(bool)? onToggleAutomatic;
  final Function(bool)? onToggleWillWatering;

  PlantItemWidget({
    Key? key, required this.plant,
    this.onToggleAutomatic,
    this.onToggleWillWatering,
  }) : super(key: ValueKey(plant.idObjectProfile));

  Color getStateColor(int? state) {
    if (state == 5) return const Color(0xFFE53935); // Rouge 600
    if (state == 3 || state == 4) return const Color(0xFFFFA000); // Amber 700
    if (state == 1 || state == 2) return const Color(0xFF43A047); // Green 600
    return const Color(0xFF9E9E9E); // Grey 500
  }

  @override
  Widget build(BuildContext context) {
    final pathPicture = plant.plantType.pathPicture;
    final stateColor = getStateColor(plant.state);

    return InkWell(
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
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: stateColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE HEADER
            if (pathPicture != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      Uri.parse(AppConfig.baseUrlDataset)
                          .resolve(pathPicture)
                          .toString(),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    // Overlay léger pour effet pro
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Badge état
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: stateColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getStateText(plant.state),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: SizedBox(
                    width: double.infinity, // Occupe toute la largeur de la card
                    child: Text(
                      plant.title ?? "Nom inconnu",
                      textAlign: TextAlign.center, // Aligne le texte au centre du SizedBox
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Plus propre pour un titre
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ),


          ],
        ),
      ),
    );
  }
}