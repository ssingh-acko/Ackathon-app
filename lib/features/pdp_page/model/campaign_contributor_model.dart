class CampaignFundingResponse {
  final bool success;
  final CampaignFundingData data;
  final String timestamp;

  CampaignFundingResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory CampaignFundingResponse.fromJson(Map<String, dynamic> json) {
    return CampaignFundingResponse(
      success: json["success"] ?? false,
      data: CampaignFundingData.fromJson(json["data"]),
      timestamp: json["timestamp"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "timestamp": timestamp,
  };
}

class CampaignFundingData {
  final String id;
  final String issueId;
  final double amountRequired;
  final double amountCollected;
  final String endDate;
  final String status;
  final List<Contributor> contributors;
  final String createdAt;
  final String updatedAt;

  CampaignFundingData({
    required this.id,
    required this.issueId,
    required this.amountRequired,
    required this.amountCollected,
    required this.endDate,
    required this.status,
    required this.contributors,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignFundingData.fromJson(Map<String, dynamic> json) {
    return CampaignFundingData(
      id: json["id"] ?? "",
      issueId: json["issueId"] ?? "",
      amountRequired: (json["amountRequired"] ?? 0).toDouble(),
      amountCollected: (json["amountCollected"] ?? 0).toDouble(),
      endDate: json["endDate"] ?? "",
      status: json["status"] ?? "",
      contributors: (json["contributors"] as List? ?? [])
          .map((e) => Contributor.fromJson(e))
          .toList(),
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "issueId": issueId,
    "amountRequired": amountRequired,
    "amountCollected": amountCollected,
    "endDate": endDate,
    "status": status,
    "contributors": contributors.map((e) => e.toJson()).toList(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Contributor {
  final String id;
  final String campaignId;
  final int userId;
  final String username;
  final String firstName;
  final String lastName;
  final double contributionAmount;
  final String createdAt;

  Contributor({
    required this.id,
    required this.campaignId,
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.contributionAmount,
    required this.createdAt,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      id: json["id"] ?? "",
      campaignId: json["campaignId"] ?? "",
      userId: json["userId"] ?? 0,
      username: json["username"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      contributionAmount: (json["contributionAmount"] ?? 0).toDouble(),
      createdAt: json["createdAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "campaignId": campaignId,
    "userId": userId,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "contributionAmount": contributionAmount,
    "createdAt": createdAt,
  };
}
