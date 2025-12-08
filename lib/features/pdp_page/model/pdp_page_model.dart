class MissionFundingModel {
  final String title;
  final String location;
  final String headerImage;
  final bool isMe;

  final int totalAmount;
  final int currentPaid;

  final List<HeroContributor> heroesList;

  final List<String> vendorsList; // **not used for UI yet**

  MissionFundingModel({
    required this.title,
    required this.location,
    required this.headerImage,
    required this.isMe,
    required this.totalAmount,
    required this.currentPaid,
    required this.heroesList,
    required this.vendorsList,
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
