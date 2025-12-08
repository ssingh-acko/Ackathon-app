class VendorBidsResponse {
  final bool success;
  final VendorBidsData data;
  final String timestamp;

  VendorBidsResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory VendorBidsResponse.fromJson(Map<String, dynamic> json) {
    return VendorBidsResponse(
      success: json["success"] ?? false,
      data: VendorBidsData.fromJson(json["data"]),
      timestamp: json["timestamp"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "timestamp": timestamp,
  };
}

class VendorBidsData {
  final List<VendorBidItem> content;
  final Pageable pageable;
  final int totalPages;
  final int totalElements;
  final bool last;
  final int size;
  final int number;
  final SortInfo sort;
  final int numberOfElements;
  final bool first;
  final bool empty;

  VendorBidsData({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory VendorBidsData.fromJson(Map<String, dynamic> json) {
    return VendorBidsData(
      content: (json["content"] as List)
          .map((e) => VendorBidItem.fromJson(e))
          .toList(),
      pageable: Pageable.fromJson(json["pageable"]),
      totalPages: json["totalPages"] ?? 0,
      totalElements: json["totalElements"] ?? 0,
      last: json["last"] ?? false,
      size: json["size"] ?? 0,
      number: json["number"] ?? 0,
      sort: SortInfo.fromJson(json["sort"]),
      numberOfElements: json["numberOfElements"] ?? 0,
      first: json["first"] ?? false,
      empty: json["empty"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "content": content.map((e) => e.toJson()).toList(),
    "pageable": pageable.toJson(),
    "totalPages": totalPages,
    "totalElements": totalElements,
    "last": last,
    "size": size,
    "number": number,
    "sort": sort.toJson(),
    "numberOfElements": numberOfElements,
    "first": first,
    "empty": empty,
  };
}

class VendorBidItem {
  final int id;
  final int serviceProviderId;
  final String serviceProviderName;
  final String issueId;
  final double bidAmount;
  final List<String> primaryMaterialUsed;
  final String status;
  final String valueProposition;
  final String bidLink;
  final String whyChooseTeam;
  final String createdAt;
  final String updatedAt;

  VendorBidItem({
    required this.id,
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.issueId,
    required this.bidAmount,
    required this.primaryMaterialUsed,
    required this.status,
    required this.valueProposition,
    required this.bidLink,
    required this.whyChooseTeam,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorBidItem.fromJson(Map<String, dynamic> json) {
    return VendorBidItem(
      id: json["id"],
      serviceProviderId: json["serviceProviderId"],
      serviceProviderName: json["serviceProviderName"] ?? "",
      issueId: json["issueId"] ?? "",
      bidAmount: (json["bidAmount"] ?? 0).toDouble(),
      primaryMaterialUsed: List<String>.from(json["primaryMaterialUsed"] ?? []),
      status: json["status"] ?? "",
      valueProposition: json["valueProposition"] ?? "",
      bidLink: json["bidLink"] ?? "",
      whyChooseTeam: json["whyChooseTeam"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceProviderId": serviceProviderId,
    "serviceProviderName": serviceProviderName,
    "issueId": issueId,
    "bidAmount": bidAmount,
    "primaryMaterialUsed": primaryMaterialUsed,
    "status": status,
    "valueProposition": valueProposition,
    "bidLink": bidLink,
    "whyChooseTeam": whyChooseTeam,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final SortInfo sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.sort,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json["pageNumber"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      sort: SortInfo.fromJson(json["sort"]),
      offset: json["offset"] ?? 0,
      paged: json["paged"] ?? false,
      unpaged: json["unpaged"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "sort": sort.toJson(),
    "offset": offset,
    "paged": paged,
    "unpaged": unpaged,
  };
}

class SortInfo {
  final bool sorted;
  final bool empty;
  final bool unsorted;

  SortInfo({
    required this.sorted,
    required this.empty,
    required this.unsorted,
  });

  factory SortInfo.fromJson(Map<String, dynamic> json) {
    return SortInfo(
      sorted: json["sorted"] ?? false,
      empty: json["empty"] ?? false,
      unsorted: json["unsorted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "sorted": sorted,
    "empty": empty,
    "unsorted": unsorted,
  };
}
