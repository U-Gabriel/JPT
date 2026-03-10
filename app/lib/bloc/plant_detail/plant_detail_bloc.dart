import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/object_profile.dart';
import '../../../services/object_profile_service.dart';
import 'plant_detail_event.dart';
import 'plant_detail_state.dart';

class PlantDetailBloc extends Bloc<PlantDetailEvent, PlantDetailState> {
  final ObjectProfileService service;
  final int plantId;
  final String token;

  final _plantController = StreamController<ObjectProfile>.broadcast();
  Stream<ObjectProfile> get plantStream => _plantController.stream;

  ObjectProfile? _currentPlant;
  Timer? _pollingTimer;


  PlantDetailBloc({
    required this.service,
    required this.plantId,
    required this.token,
  }) : super(PlantDetailInitial()) {
    on<LoadPlantDetail>(_onLoadPlantDetail);

    on<ToggleFavorite>(_onToggleFavorite);

    // 1. Premier chargement immédiat
    add(LoadPlantDetail(plantId, token));

    // 2. Polling automatique (Toutes les 15 secondes)
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      add(LoadPlantDetail(plantId, token));
    });
  }

  Future<void> _onLoadPlantDetail(
      LoadPlantDetail event, Emitter<PlantDetailState> emit) async {
    try {
      print("--- POLLING: Récupération des données ---");

      final fresh = await service.fetchObjectProfileDetails(plantId, token);

      _currentPlant = fresh;

      // ON FORCE LA MISE À JOUR :
      // On envoie systématiquement au stream pour que l'UI (StreamBuilder) se reconstruise
      _plantController.add(fresh);

      // On émet l'état Loaded pour le BlocBuilder
      emit(PlantDetailLoaded(fresh));

      print("Mise à jour effectuée pour: ${fresh.title}");

    } catch (e) {
      print("ERREUR POLLING: $e");
      // On n'émet l'erreur que si on n'a vraiment aucune donnée (état initial)
      if (state is! PlantDetailLoaded) {
        emit(PlantDetailError("Erreur de chargement : $e"));
      }
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _plantController.close();
    return super.close();
  }
  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<PlantDetailState> emit) async {
    if (_currentPlant == null) return;

    // On calcule la NOUVELLE valeur (l'inverse de l'actuelle)
    final bool currentStatus = _currentPlant!.isFavorite;
    final bool nextStatus = !currentStatus;

    print("DEBUG FAVORITE: Passage de $currentStatus à $nextStatus pour l'OP: $plantId");

    try {
      final success = await service.updateObjectProfile(
        idPerson: event.idPerson,
        idObjectProfile: plantId,
        otherFields: {"is_favorite": nextStatus},
        token: token,
      );

      if (success) {
        print("DEBUG FAVORITE: Update réussi sur le serveur");
        // On force le rechargement immédiat des détails pour mettre à jour _currentPlant
        add(LoadPlantDetail(plantId, token));
      } else {
        print("DEBUG FAVORITE: Le serveur a renvoyé une erreur (Status non OK)");
      }
    } catch (e) {
      print("DEBUG FAVORITE: Exception lors de l'appel : $e");
    }
  }

}