// ------------------------------------------------------------
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  final Dio _dio = Dio();
  final String issueId;
  IncidentReport? incidentReport;
  IncidentDetailsCubit(this.issueId) : super(IncidentInitial()){
    fetchIncident(issueId);
  }

  Future<void> fetchIncident(String issueId) async {
    emit(IncidentLoading());

    try {
      final url = "http://3.109.152.78:8080/api/v1/issues/$issueId";
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data["success"] == true) {
        incidentReport = IncidentReport.fromJson(response.data);
        emit(IncidentLoaded(incidentReport!));
      } else {
        emit(IncidentError("Failed to load: Server returned error"));
      }
    } catch (e) {
      emit(IncidentError("Error: $e"));
    }
  }

}

// ------------------------------------------------------------
// INCIDENT REPORT MODEL
// ------------------------------------------------------------
class IncidentReport {
  final String id;
  final String title;
  final String reporterName;
  final String address;
  final List<String> imageUrls;
  final List<String> imageCaptions;

  final DangerInfo dangerInfo;
  final List<IncidentMeta> metadata;
  final List<String> tags;

  final AIAnalysis? ai; // <---- NEW

  IncidentReport({
    required this.id,
    required this.title,
    required this.reporterName,
    required this.address,
    required this.imageUrls,
    required this.imageCaptions,
    required this.dangerInfo,
    required this.metadata,
    required this.tags,
    required this.ai,
  });

  factory IncidentReport.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final issue = data;
    final ai = data["aiAnalysis"];

    final level = ai?["severityLevel"] ?? "MEDIUM";
    final color = _dangerColor(level);

    // captions from analysisImages
    final captions = (ai?["imageDescriptions"] as List<dynamic>? ?? [])
        .map((e) => e["description"] as String? ?? "")
        .toList();

    return IncidentReport(
      id: issue["id"],
      title: issue["title"] ?? "",
      reporterName: issue["reporterId"] ?? "User ${issue["reporterId"]}",
      address: issue["address"] ?? "",
      imageUrls: List<String>.from(issue["imageUrls"] ?? []),
      imageCaptions: captions,
      dangerInfo: DangerInfo(
        text: "${level.toString().toUpperCase()} SEVERITY",
        color: color,
        level: level,
      ),
      metadata: [
        IncidentMeta(
          icon: Symbols.category,
          label: "Category",
          value: issue["category"] ?? "-",
        ),
        IncidentMeta(
          icon: Symbols.location_on,
          label: "Locality",
          value: issue["locality"] ?? "-",
        ),
        IncidentMeta(
          icon: Symbols.calendar_month,
          label: "Created",
          value: issue["createdAt"] ?? "-",
        ),
        if (ai?["estimatedBudget"] != null)
          IncidentMeta(
            icon: Symbols.construction,
            label: "AI Estimated Budget",
            value: ai["estimatedBudget"].toString(),
          ),
      ],
      tags: [],
      ai: ai != null ? AIAnalysis.fromJson(ai) : null,
    );
  }
}


// ---------------------------------------------------------
// DangerInfo
// ---------------------------------------------------------
class DangerInfo {
  final String text;
  final Color color;
  final String level;

  DangerInfo({
    required this.text,
    required this.color,
    required this.level,
  });
}

// ---------------------------------------------------------
// Metadata row
// ---------------------------------------------------------
class IncidentMeta {
  final IconData icon;
  final String label;
  final String value;

  IncidentMeta({
    required this.icon,
    required this.label,
    required this.value,
  });
}

// ---------------------------------------------------------
// Color mapping for severity
// ---------------------------------------------------------
Color _dangerColor(String level) {
  switch (level.toUpperCase()) {
    case "HIGH":
      return Colors.red;
    case "MEDIUM":
      return Colors.orange;
    case "LOW":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

class AIAnalysis {
  final String id;
  final double? estimatedBudget;
  final String? budgetBreakdown;
  final String? estimatedCompletionTime;
  final String? issueSummary;

  final TechnicalNotes? technicalNotes;
  final String? recommendations;
  final String severityLevel;

  final List<AIImageDescription> imageDescriptions;
  final Map<String, dynamic> additionalData;

  final String createdAt;
  final String updatedAt;

  AIAnalysis({
    required this.id,
    required this.estimatedBudget,
    required this.budgetBreakdown,
    required this.estimatedCompletionTime,
    required this.issueSummary,
    required this.technicalNotes,
    required this.recommendations,
    required this.severityLevel,
    required this.imageDescriptions,
    required this.additionalData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      id: json["id"],
      estimatedBudget:
      json["estimatedBudget"] != null ? json["estimatedBudget"] * 1.0 : null,
      budgetBreakdown: json["budgetBreakdown"],
      estimatedCompletionTime: json["estimatedCompletionTime"],
      issueSummary: json["issueSummary"],
      technicalNotes: json["technicalNotes"] != null
          ? TechnicalNotes.fromJson(json["technicalNotes"])
          : null,
      recommendations: json["recommendations"],
      severityLevel: json["severityLevel"] ?? "MEDIUM",
      imageDescriptions: (json["imageDescriptions"] as List<dynamic>? ?? [])
          .map((e) => AIImageDescription.fromJson(e))
          .toList(),
      additionalData: json["additionalData"] ?? {},
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}
class AIImageDescription {
  final String imageUrl;
  final String description;

  AIImageDescription({
    required this.imageUrl,
    required this.description,
  });

  factory AIImageDescription.fromJson(Map<String, dynamic> json) {
    return AIImageDescription(
      imageUrl: json["imageUrl"] ?? "",
      description: json["description"] ?? "",
    );
  }
}

class TechnicalNotes {
  final String? potholeType;
  final int? depthEstimateCm;
  final String? roadType;
  final double? widthSpreadM;
  final String? structuralCondition;
  final List<String> riskAmplifiers;

  TechnicalNotes({
    required this.potholeType,
    required this.depthEstimateCm,
    required this.roadType,
    required this.widthSpreadM,
    required this.structuralCondition,
    required this.riskAmplifiers,
  });

  factory TechnicalNotes.fromJson(Map<String, dynamic> json) {
    return TechnicalNotes(
      potholeType: json["pothole_type"],
      depthEstimateCm: json["depth_estimate_cm"],
      roadType: json["road_type"],
      widthSpreadM:
      json["width_spread_m"] != null ? json["width_spread_m"] * 1.0 : null,
      structuralCondition: json["structural_condition"],
      riskAmplifiers:
      List<String>.from(json["risk_amplifiers"] ?? []),
    );
  }
}
