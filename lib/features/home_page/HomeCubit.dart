import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'home_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API

    final locality = await _getUserLocality();

    emit(HomeLoaded(
      locality: locality,
      homeActionCards: homeActionCards,     // your existing hardcoded data
      nearbyIssues: nearbyIssues,           // same here
    ));
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    await loadHomeData();
  }

  Future<String> _getUserLocality() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return "Location Disabled";
    }

    Position pos = await Geolocator.getCurrentPosition();
    List<Placemark> pm =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    return pm.isNotEmpty ? pm.first.locality ?? "Unknown" : "Unknown";
  }
}

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String locality;
  final List<HomeActionCard> homeActionCards;
  final List<NearbyIssue> nearbyIssues;

  HomeLoaded({
    required this.locality,
    required this.homeActionCards,
    required this.nearbyIssues,
  });
}

