class MissionStatusResponse {
  final bool success;
  final List<MissionStatusItem> data;
  final String timestamp;

  MissionStatusResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory MissionStatusResponse.fromJson(Map<String, dynamic> json) {
    return MissionStatusResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>)
          .map((e) => MissionStatusItem.fromJson(e))
          .toList(),
      timestamp: json["timestamp"] ?? "",
    );
  }
}


class MissionStatusItem {
  final int id;
  final String issueId;
  final String issueTitle;
  final int serviceProviderId;
  final String serviceProviderName;
  final String description;
  final String status;
  final List<String> imageUrls;
  final Map<String, dynamic> additionalDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  MissionStatusItem({
    required this.id,
    required this.issueId,
    required this.issueTitle,
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.description,
    required this.status,
    required this.imageUrls,
    required this.additionalDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MissionStatusItem.fromJson(Map<String, dynamic> json) {
    return MissionStatusItem(
      id: json["id"] ?? 0,
      issueId: json["issueId"] ?? "",
      issueTitle: json["issueTitle"] ?? "",
      serviceProviderId: json["serviceProviderId"] ?? 0,
      serviceProviderName: json["serviceProviderName"] ?? "",
      description: json["description"] ?? "",
      status: json["status"] ?? "",
      imageUrls: (json["imageUrls"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      additionalDetails: json["additionalDetails"] ?? {},
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
