import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'home_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());
  final Dio _dio = Dio();
  List<String> allowedStatus = [ 'CROWDFUNDING',
    'SCHEDULING',
    'WORK_IN_PROGRESS',
    'COMPLETED'];

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API

    final locality = await _getUserLocality();

    final getAllIssuesApi = "http://3.109.152.78:8080/api/v1/issues";
    final response = await _dio.get(getAllIssuesApi);
    final data = IssueListResponse.fromJson(response.data);

    emit(HomeLoaded(
      locality: locality,
      homeActionCards: homeActionCards,     // your existing hardcoded data
      nearbyIssues: data.data.content.where((content) => allowedStatus.contains(content.status)).map((issue) => NearbyIssue(
        title: issue.title ?? "",
        imageUrl: issue.imageUrl.isEmpty ? "https://lh3.googleusercontent.com/aida-public/AB6AXuCSPjkqAGMxouRpNu20f9jvCZFvR79dtIP0htxONzzDFV5QoQZ6-lzIreLJp4RePl-_5_qbay1T3AH-fDYJw1v2jFO7QcAoWAMr93PC6S2HKqG_e68pzV7XWsqccvwRKnd1hVdAGor1OjCuVZF7V0OvQUJ27eawTeFx5dgNm6aGw_21WKvnrbCh_S31Q1QOtSuh4XgM_BCssO1cy16VeKWgVEHJVz8oT88clq4oudDWn80VnaM6nV_bDc3Aay0nQAUli7Znx0Nfsc4": issue.imageUrl,
        severity: 'HIGH SEVERITY',
        id: issue.id,
        status: issue.status,
        severityColor: Color(0xFFB91C1C),
        severityBg: Color(0xFFFEE2E2),
        progress: (issue.fundedPercentage == 0) ? 75 : 0,
        isCompleted: false,
      )).toList(),           // same here
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

