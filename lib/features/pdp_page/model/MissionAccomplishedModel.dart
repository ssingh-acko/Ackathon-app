class MissionAccomplishedModel {
  final String issueId;
  final String title;
  final String description;
  final String beforeImage;
  final String afterImage;
  final int totalFunders;
  final String vendorName;

  MissionAccomplishedModel({
    required this.issueId,
    required this.title,
    required this.description,
    required this.beforeImage,
    required this.afterImage,
    required this.totalFunders,
    required this.vendorName,
  });

  factory MissionAccomplishedModel.mock(String issueId) {
    return MissionAccomplishedModel(
      issueId: issueId,
      title: "Potholes on Main St Fixed!",
      description:
          "From a dangerous pothole to a perfectly repaired surface—thanks to community support.",
      beforeImage:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuBY_erWtkTlDgL5J5OLHcFIyBCc1GKEU5p39_Sah6c_S3TXp2kA4h02vHfXu7OnF7hspMfAVM5uRNoVJXWAJe_HhXSbSIc_iIeYp8KCRG8_8Xjk4yym_xfhlB5A01noLKQbT2Zcymmlloarag242R-iF-qWCxplM6y30AXncTpW6BYye3dp6aakwvguQmeY-5vaGlwycp5Y02VYDnj8fl3olADYTCLgkhld_M5s3v6lQ2FZMXJYLWIV6bK60d6c995B6uiPFOxBf4c",
      afterImage:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDg-n3AA3PmPTUJbtYc6_1suE6PDqeRkdkhW9F9-BjPJ9z59Ie147oztbNvlEYNvVAjyDivuodmrjw11mroMf2V_r0DDXjcdSDIMkilGbGJ-KylqQmvAgjfPPoPlb-LNyYKYls4KQ_Sdl-SFStTu1XA8L1CgyrhpR-RHYDFtkfRkhxZq-UUuAX-HEGqc_Ru6PmDvTsDEiF9wpbcX5sf5AsvyM5h-01hdr4Pt5EFf5xE7v8r2mIyghhdgvqnxWTVtGdIiu6o1h2un8k",
      totalFunders: 25,
      vendorName: "FixIt Crew",
    );
  }
}
