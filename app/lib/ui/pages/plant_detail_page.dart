import 'package:app/ui/pages/widget/popup/delete_confirm_dialog.dart';
import 'package:app/ui/pages/widget/tools/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/object_profile_service.dart';
import '../../bloc/plant_detail/plant_detail_bloc.dart';
import '../../bloc/plant_detail/plant_detail_event.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/object_profile.dart';
import 'package:app/ui/pages/widget/plant_card_favorite/plant_control_switches_widget.dart';

class PlantDetailPage extends StatefulWidget {
  final int plantId;
  const PlantDetailPage({super.key, required this.plantId});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  String _imageVersion = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().accessToken;
    final localL10n = AppLocalizations.of(context)!;

    if (token == null) return Scaffold(body: Center(child: Text(localL10n.sessionExpired)));

    return BlocProvider(
      create: (_) => PlantDetailBloc(
        service: ObjectProfileService(),
        plantId: widget.plantId,
        token: token,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            final bloc = context.read<PlantDetailBloc>();
            final localL10n = AppLocalizations.of(context)!;

            return StreamBuilder<ObjectProfile>(
              stream: bloc.plantStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("${localL10n.errorPrefix} ${snapshot.error}"));
                if (!snapshot.hasData) return _buildLoadingShimmer(context);

                final plant = snapshot.data!;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.30,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: Icon(
                            plant.isFavorite ? Icons.star : Icons.star_border,
                            color: plant.isFavorite ? Colors.yellow[600] : Colors.white,
                          ),
                          onPressed: () {
                            final userIdString = context.read<AuthProvider>().userId;
                            final userId = int.tryParse(userIdString ?? '') ?? 0;
                            final bool wasFavorite = plant.isFavorite;
                            context.read<PlantDetailBloc>().add(ToggleFavorite(userId));
                            _showSnack(
                                context,
                                !wasFavorite ? localL10n.addedToFavorites : localL10n.removedFromFavorites,
                                !wasFavorite ? Colors.green : Colors.orange
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black.withOpacity(0.5),
                              isScrollControlled: true,
                              builder: (BuildContext bottomSheetContext) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            localL10n.deviceOptionsTitle,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 20),
                                          _buildBottomSheetItem(
                                            icon: Icons.settings_input_component,
                                            iconColor: Colors.green,
                                            title: localL10n.wateringSettingsTitle,
                                            subtitle: localL10n.wateringSettingsSubtitle,
                                            onTap: () {
                                              Navigator.pop(bottomSheetContext);
                                              Navigator.pushNamed(
                                                context,
                                                '/group_plant_type',
                                                arguments: {
                                                  'objectProfileId': plant.idObjectProfile,
                                                  'plantId': plant.plantDetails.typeId,
                                                },
                                              );
                                            },
                                          ),
                                          const Divider(height: 1, indent: 52),
                                          _buildBottomSheetItem(
                                            icon: Icons.wifi,
                                            iconColor: Colors.blue,
                                            title: localL10n.modifyWifiTitle,
                                            subtitle: localL10n.modifyWifiSubtitle,
                                            onTap: () {
                                              Navigator.pop(bottomSheetContext);
                                              Navigator.pushNamed(
                                                context,
                                                '/modification_wifi_my_object',
                                                arguments: {
                                                  'objectProfileId': plant.idObjectProfile,
                                                  'title': plant.title,
                                                },
                                              );
                                            },
                                          ),
                                          const Divider(height: 1, indent: 52),
                                          _buildBottomSheetItem(
                                            icon: Icons.quiz_rounded,
                                            iconColor: Colors.purple,
                                            title: localL10n.helpFaqTitle,
                                            subtitle: localL10n.helpFaqSubtitle,
                                            onTap: () {
                                              Navigator.pop(bottomSheetContext);
                                              Navigator.pushNamed(context, '/profile_faq');
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(plant.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(blurRadius: 10, color: Colors.black)]
                            )
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            ImageHelper.buildPlantImage(path: plant.pathPicture),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black54, Colors.transparent],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                child: const Icon(Icons.edit, color: Colors.green),
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    '/change_op_pp_page',
                                    arguments: {
                                      'objectProfileId': plant.idObjectProfile,
                                      'currentPath': plant.pathPicture,
                                    },
                                  );

                                  if (result == true && mounted) {
                                    setState(() {
                                      _imageVersion = DateTime.now().millisecondsSinceEpoch.toString();
                                    });
                                    bloc.add(LoadPlantDetail(plant.idObjectProfile, token));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(plant, context, localL10n),
                            const SizedBox(height: 16),
                            _buildConnectionStatus(plant, localL10n),
                            const SizedBox(height: 16),
                            _buildAnalysisCard(plant, localL10n),
                            const SizedBox(height: 24),
                            _buildModeBanner(plant, localL10n),
                            const SizedBox(height: 24),
                            PlantControlSwitches(plant: plant),
                            const SizedBox(height: 32),
                            Text(localL10n.stateSensorsTitle,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                            ),
                            const SizedBox(height: 16),
                            _buildSensorGrid(plant, localL10n),
                            const SizedBox(height: 32),
                            _buildInfoSection(
                                localL10n.aboutTitle,
                                (plant.description == null || plant.description.isEmpty)
                                    ? localL10n.noDescription
                                    : plant.description
                            ),
                            _buildInfoSection(
                                localL10n.maintenanceAdviceTitle,
                                (plant.advise == null || plant.advise!.isEmpty)
                                    ? localL10n.noMaintenanceAdvice
                                    : plant.advise!
                            ),
                            const SizedBox(height: 16),
                            _buildDeviceOptions(plant, context, localL10n),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceOptions(ObjectProfile plant, BuildContext context, AppLocalizations localL10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localL10n.deviceOptionsSectionTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                _buildMenuRow(
                  icon: Icons.settings_input_component,
                  iconColor: Colors.green,
                  title: localL10n.wateringParamsTitle,
                  subtitle: localL10n.wateringSettingsSubtitle,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/group_plant_type',
                      arguments: {
                        'objectProfileId': plant.idObjectProfile,
                        'plantId': plant.plantDetails.typeId,
                      },
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildMenuRow(
                  icon: Icons.wifi_find,
                  iconColor: Colors.blue,
                  title: localL10n.wifiModificationTitle,
                  subtitle: localL10n.wifiModificationSubtitle,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/modification_wifi_my_object',
                      arguments: {
                        'objectProfileId': plant.idObjectProfile,
                        'title': plant.title,
                      },
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildMenuRow(
                  icon: Icons.quiz_rounded,
                  iconColor: Colors.purple,
                  title: localL10n.helpFaqTitle,
                  subtitle: localL10n.helpFaqObjectSubtitle,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile_faq');
                  },
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildMenuRow(
                  icon: Icons.delete_outline,
                  iconColor: Colors.red,
                  title: localL10n.deleteObjectTitle,
                  subtitle: localL10n.deleteObjectSubtitle,
                  isDestructive: true,
                  onTap: () => _handleDelete(context, plant, localL10n),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDestructive ? Colors.red[700] : iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red[700] : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      onTap: onTap,
    );
  }

  Widget _buildHeader(ObjectProfile plant, BuildContext context, AppLocalizations localL10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.plantDetails.typeTitle,
                style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/plant_detail_known', arguments: plant.plantDetails.typeId);
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("${localL10n.groupPrefix} ${plant.plantDetails.groupTitle}", style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.2)),
                    const SizedBox(width: 6),
                    Icon(Icons.info_outline, size: 16, color: Colors.green.withOpacity(0.7)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Chip(
            backgroundColor: _getHealthColor(plant.state).withOpacity(0.1),
            side: BorderSide(color: _getHealthColor(plant.state)),
            label: Text(
              getStateText(plant.state).toUpperCase(),
              style: TextStyle(color: _getHealthColor(plant.state), fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus(ObjectProfile plant, AppLocalizations localL10n) {
    final bool isStable = _isConnectionStable(plant.lastUpdate, maxDays: 1) || _isConnectionStable(plant.lastWatering, maxDays: 6);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isStable ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isStable ? Colors.green[200]! : Colors.red[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(isStable ? Icons.wifi_tethering : Icons.wifi_tethering_off, color: isStable ? Colors.green[700] : Colors.red[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isStable ? localL10n.connectedStable : localL10n.connectedUnstable,
              style: TextStyle(color: isStable ? Colors.green[800] : Colors.red[800], fontSize: 13, fontWeight: FontWeight.w500, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeBanner(ObjectProfile plant, AppLocalizations localL10n) {
    final bool isAuto = plant.isAutomatic ?? false;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAuto ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isAuto ? Colors.green[200]! : Colors.orange[200]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isAuto ? Icons.auto_fix_high : Icons.handyman, color: isAuto ? Colors.green[700] : Colors.orange[700]),
              const SizedBox(width: 12),
              Text(
                isAuto ? localL10n.autoModeActive : localL10n.manualModeActive,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1, color: isAuto ? Colors.green[800] : Colors.orange[800]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAuto ? localL10n.autoModeDesc : localL10n.manualModeDesc,
            style: TextStyle(color: isAuto ? Colors.green[900] : Colors.orange[900], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _handleDelete(BuildContext context, ObjectProfile plant, AppLocalizations localL10n) {
    final authProvider = context.read<AuthProvider>();
    final userId = int.tryParse(authProvider.userId ?? '') ?? 0;

    DeleteConfirmDialog.show(
      context,
      title: localL10n.deleteDialogTitle,
      message: localL10n.deleteDialogMessage(plant.title),
      onConfirm: () async {
        final statusCode = await ObjectProfileService().deleteObjectProfile(
          idPerson: userId,
          idObjectProfile: plant.idObjectProfile,
        );

        if (!context.mounted) return;

        switch (statusCode) {
          case 200:
            _showSnack(context, localL10n.deleteSuccess, Colors.green);
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 403:
            _showSnack(context, localL10n.deleteForbidden, Colors.orange);
            break;
          default:
            _showSnack(context, localL10n.deleteError, Colors.red);
        }
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
            backgroundColor: Colors.white,
            flexibleSpace: const FlexibleSpaceBar(background: SizedBox.expand()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 30, width: 200, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(height: 50, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorGrid(ObjectProfile plant, AppLocalizations localL10n) {
    final sensors = plant.sensors;
    final double? avgUv = sensors.averages['uv'];
    final bool isSunExposedToday = _hasSunExposureToday(plant.lastUvExposureDate);
    final uvDisplay = _getUvDisplay(avgUv, localL10n);

    String format(double? val) => val != null ? val.toStringAsFixed(1) : '--';

    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildSensorTile(localL10n.sensorTemp, "${format(sensors.averages['temp'])}°C", sensors.targets['temp'], Icons.thermostat, localL10n),
            _buildSensorTile(localL10n.sensorFertility, "${format(sensors.averages['fertility'])}%", sensors.targets['fertility'], Icons.science, localL10n),
            _buildSensorTile(localL10n.sensorHumAir, "${format(sensors.averages['hum_air'])}%", sensors.targets['hum_air'], Icons.cloud, localL10n),
            _buildCustomUvTile(localL10n.sensorLight, uvDisplay["text"], uvDisplay["color"], Icons.wb_sunny_rounded),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSunExposedToday ? Colors.amber[50] : Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSunExposedToday ? Colors.amber[200]! : Colors.blueGrey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(isSunExposedToday ? Icons.brightness_high : Icons.cloud_queue, color: isSunExposedToday ? Colors.amber[800] : Colors.blueGrey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    localL10n.sunExposureToday(isSunExposedToday ? 'OUI' : 'NON'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSunExposedToday ? Colors.amber[900] : Colors.blueGrey[800]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(_getUvAdvice(avgUv, localL10n), style: TextStyle(fontSize: 13, height: 1.4, color: isSunExposedToday ? Colors.amber[900] : Colors.blueGrey[900])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorTile(String label, String value, dynamic target, IconData icon, AppLocalizations localL10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          FittedBox(child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          if (target != null) Text(localL10n.sensorTarget(target.toString()), style: TextStyle(fontSize: 9, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildCustomUvTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(ObjectProfile plant, AppLocalizations localL10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.orange[100]!)),
      child: Column(
        children: [
          Row(children: [const Icon(Icons.psychology, color: Colors.green), const SizedBox(width: 12), Text(localL10n.analysisProTitle, style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          Text(plant.adviceRealtime ?? localL10n.analysisLoading, style: const TextStyle(color: Colors.black, fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15)),
      ]),
    );
  }

  bool _isConnectionStable(String? dateString, {int maxDays = 1}) {
    if (dateString == null) return false;
    try {
      final lastDate = DateTime.parse(dateString).toLocal();
      return DateTime.now().difference(lastDate).inDays <= maxDays;
    } catch (e) { return false; }
  }

  Color _getHealthColor(int? state) => (state ?? 0) <= 2 ? Colors.green : (state ?? 0) <= 4 ? Colors.orange : Colors.red;

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating, duration: const Duration(milliseconds: 800)));
  }

  String _getUvAdvice(double? uvValue, AppLocalizations localL10n) {
    if (uvValue == null) return localL10n.uvNoData;
    if (uvValue <= 2.0) return localL10n.uvLowData;
    if (uvValue <= 5.0) return localL10n.uvMediumData;
    if (uvValue <= 7.0) return localL10n.uvHighData;
    return localL10n.uvExtremeData;
  }

  bool _hasSunExposureToday(String? lastUvDateString) {
    if (lastUvDateString == null) return false;
    try {
      final lastUvDate = DateTime.parse(lastUvDateString).toLocal();
      final now = DateTime.now();
      return lastUvDate.year == now.year && lastUvDate.month == now.month && lastUvDate.day == now.day;
    } catch (e) { return false; }
  }

  Map<String, dynamic> _getUvDisplay(double? uvValue, AppLocalizations localL10n) {
    if (uvValue == null) return {"text": localL10n.uvDisplayNone, "color": Colors.grey};
    if (uvValue <= 2.0) return {"text": localL10n.uvDisplayLow, "color": Colors.blueGrey};
    if (uvValue <= 5.0) return {"text": localL10n.uvDisplayModerate, "color": Colors.green};
    if (uvValue <= 7.0) return {"text": localL10n.uvDisplayHigh, "color": Colors.orange};
    if (uvValue <= 10.0) return {"text": localL10n.uvDisplayVeryHigh, "color": Colors.red};
    return {"text": localL10n.uvDisplayCritical, "color": Colors.purple};
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      onTap: onTap,
    );
  }
}