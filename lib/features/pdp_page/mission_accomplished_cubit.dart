import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../incident_details/cubit.dart';
import 'model/MissionAccomplishedModel.dart';
import 'model/campaign_contributor_model.dart';
import 'model/mission_status_response.dart';

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
  String? fixedImage;

  Future<void> loadMission(String issueId) async {
    emit(MissionAccomplishedLoading());
    final milestoneUrl =
        "http://3.109.152.78:8080/api/v1/milestones/issue/$issueId";

    final milestoneResponse = await _dio.get(milestoneUrl);

    final milestoneResponseModel = MissionStatusResponse.fromJson(milestoneResponse.data);

    fixedImage = milestoneResponseModel.data.where((element) {
      return element.status.compareTo("COMPLETED") == 0;
    }).first.imageUrls.first;

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

      final data = MissionAccomplishedModel(issueId: incidentReport.id, title: incidentReport.title, description: "From a dangerous pothole to a perfectly repaired surface—thanks to community support.", beforeImage: incidentReport.imageUrls.first, afterImage: fixedImage!, totalFunders: campaignFundingResponse.data.contributors.length, vendorName: 'Sharan');

      emit(MissionAccomplishedLoaded(data));
    } catch (e) {
      emit(MissionAccomplishedError("Failed to load mission"));
    }
  }
}
