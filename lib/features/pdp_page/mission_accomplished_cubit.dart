import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../incident_details/cubit.dart';
import 'model/MissionAccomplishedModel.dart';
import 'model/campaign_contributor_model.dart';

class MissionAccomplishedState {}

class MissionAccomplishedLoading extends MissionAccomplishedState {}

class MissionAccomplishedLoaded extends MissionAccomplishedState {
  final MissionAccomplishedModel data;

  MissionAccomplishedLoaded(this.data);
}

class MissionAccomplishedError extends MissionAccomplishedState {
  final String message;

  MissionAccomplishedError(this.message);
}

class MissionAccomplishedCubit extends Cubit<MissionAccomplishedState> {
  MissionAccomplishedCubit() : super(MissionAccomplishedLoading());
  final Dio _dio = Dio();

  Future<void> loadMission(String issueId) async {
    emit(MissionAccomplishedLoading());
    final incidentUrl = "http://3.109.152.78:8080/api/v1/issues/$issueId";
    final incidentResponse = await _dio.get(incidentUrl);
    final contributorUrl =
        "http://3.109.152.78:8080/api/v1/crowdfunding/campaigns/issue/$issueId";
    final contributorResponse = await _dio.get(contributorUrl);

    CampaignFundingResponse? campaignFundingResponse =
    CampaignFundingResponse.fromJson(contributorResponse.data);
    IncidentReport? incidentReport = IncidentReport.fromJson(
      incidentResponse.data,
    );
    try {

      final data = MissionAccomplishedModel(issueId: incidentReport.id, title: incidentReport.title, description: "From a dangerous pothole to a perfectly repaired surface—thanks to community support.", beforeImage: incidentReport.imageUrls.first, afterImage: "https://lh3.googleusercontent.com/aida-public/AB6AXuBY_erWtkTlDgL5J5OLHcFIyBCc1GKEU5p39_Sah6c_S3TXp2kA4h02vHfXu7OnF7hspMfAVM5uRNoVJXWAJe_HhXSbSIc_iIeYp8KCRG8_8Xjk4yym_xfhlB5A01noLKQbT2Zcymmlloarag242R-iF-qWCxplM6y30AXncTpW6BYye3dp6aakwvguQmeY-5vaGlwycp5Y02VYDnj8fl3olADYTCLgkhld_M5s3v6lQ2FZMXJYLWIV6bK60d6c995B6uiPFOxBf4c", totalFunders: campaignFundingResponse.data.contributors.length, vendorName: 'Sharan');

      emit(MissionAccomplishedLoaded(data));
    } catch (e) {
      emit(MissionAccomplishedError("Failed to load mission"));
    }
  }
}
