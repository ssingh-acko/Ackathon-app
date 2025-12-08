class MissionFundingModel {
  final String title;
  final String location;
  final String headerImage;
  final bool isMe;

  final int totalAmount;
  final int currentPaid;

  final List<HeroContributor> heroesList;

  final List<VendorBid> vendorBids;

  MissionFundingModel({
    required this.title,
    required this.location,
    required this.headerImage,
    required this.isMe,
    required this.totalAmount,
    required this.currentPaid,
    required this.heroesList,
    this.vendorBids = const [],
  });

  double get fundedPercent => currentPaid / totalAmount;
  int get remainingAmount => totalAmount - currentPaid;
}

class HeroContributor {
  final String name;
  final String imageUrl;
  final int amount;

  HeroContributor({
    required this.name,
    required this.imageUrl,
    required this.amount,
  });
}

class VendorInfo {
  final String name;
  final String imageUrl;
  final int amount;

  VendorInfo({
    required this.name,
    required this.imageUrl,
    required this.amount,
  });
}

class VendorBid {
  final String vendorName;
  final String avatar;
  final double proposedAmount;
  final String timeline;
  final double rating;
  final int reviews;
  final String status; // pending, rejected, considered, critical
  final int thumbsUp;
  final List<String> materialUsed;
  final String whyChooseMe;

  VendorBid({
    required this.vendorName,
    required this.avatar,
    required this.proposedAmount,
    required this.timeline,
    required this.rating,
    required this.reviews,
    required this.status,
    this.thumbsUp = 0,
    required this.materialUsed,
    required this.whyChooseMe,
  });
}
