// ------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'model/incident_detail_model.dart';

abstract class IncidentDetailsState {}

class IncidentInitial extends IncidentDetailsState {}

class IncidentLoading extends IncidentDetailsState {}

class IncidentLoaded extends IncidentDetailsState {
  final IncidentReport data;
  IncidentLoaded(this.data);
}

class IncidentError extends IncidentDetailsState {
  final String message;
  IncidentError(this.message);
}

// ------------------------------------------------------------
// CUBIT
// ------------------------------------------------------------
class IncidentDetailsCubit extends Cubit<IncidentDetailsState> {
  IncidentDetailsCubit() : super(IncidentInitial());

  Future<void> fetchIncident() async {
    emit(IncidentLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      final mockData = IncidentReport(
        title: "HSR SPIKY DEATH CRATER",
        reporterName: "Vikas ❤️",
        address: "27th Main Rd, HSR Layout",
        imageUrls: [
          "https://lh3.googleusercontent.com/aida-public/AB6AXuC6P2UK5KTB7WxXGwT4SBJ8w3X7jl0vK1qxKq5Ys3y4s44l-p4X6l_ebfy3t1VB1RqFY_JyrX-FdcCOX2EYdLd8YwT4ppmttY1HerhSMUPmPiaTAYOTdx84J8teUx3mIz1zFPeemeVd-FIWXvJAkaBuaVavrF1svx5V_wIAE3xYM08N4hVsT6lslMK_GSJi4gJ7tynV7mCS6V2aF9iUcGNWNq-Cq_BlEwc5v_athoI01Vn2qPOKMBBriIGYXh-wUTVqyQTssy7xwsg",
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDICLJQ1FyojwZbJvtA97hTOOwLSdhwfwBnxIGx9lnoriQGtzmEnYElh21UYPSEVUvzUYr0elrpJ71JMWYR0KhpkDElXWEHe5vo5rVrXZe_Yd0QqYilVq_4nrklsKiJVOtLuovPQoRdagVKljIX26z2ibSsyiK4R9V10QLuT_xXMXASFMmhQY7r6gG2ohN0_KkXuXjdhwqMjwr-PRsvLvfKGnRlxw6loN5A5hyxAmft9ddtmiR-Tb9rhzb545KPIL6boNg6isXGXiM",
          "https://lh3.googleusercontent.com/aida-public/AB6AXuBNwmEJbzdN3rWpOFk763Sx92jCRrDG4EcoDw3FdPRg3y_OpXY8_g51jq7XzSjhHGkOzTan0_0zjMC2jvS7SWoCaVC1HlDn_GndxA3e4a0TPrpmQBdmX92e0_tFNlof47scXIScjvHIeNDi7FqFAwBsBnnh1Pllm049jW4d9tJ3udjO4PXJglII2fqzD1YKdd1E37NYVFfKtLuxDNE4um1a-_aTlo2iO2A1E99e7-i29aeyU3ajZqAjNRVN6hCdeWsgs9AbchU2IB8",
        ],
        imageCaptions: [
          "Full view – Swiggy guys are literally dancing around it",
          "Standing over it – your foot for scale",
          "Close-up of the killer metal pipe sticking out",
        ],
        dangerInfo: DangerInfo(
          text: "EXTREMELY DANGEROUS (Red Alert)",
          color: Colors.red,
          level: "high",
        ),
        metadata: [
          IncidentMeta(
            icon: Symbols.personal_injury,
            label: "Known accident",
            value: "1 delivery boy already fell last week",
          ),
          IncidentMeta(
            icon: Symbols.two_wheeler,
            label: "Most affected",
            value: "Swiggy / Zomato annas on bikes",
          ),
        ],
        tags: [],
      );

      emit(IncidentLoaded(mockData));
    } catch (e) {
      emit(IncidentError("Failed to load incident details"));
    }
  }
}