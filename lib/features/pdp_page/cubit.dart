import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../incident_details/cubit.dart';
import 'model/campaign_contributor_model.dart';
import 'model/mission_status_response.dart';
import 'model/pdp_page_model.dart';
import 'model/vendor_api_model.dart';

// ------------------------------------------------------------
// STATES
// ------------------------------------------------------------
abstract class MissionFundingState {}

class MissionFundingInitial extends MissionFundingState {}

class MissionFundingLoading extends MissionFundingState {}

class MissionFundingLoaded extends MissionFundingState {
  final MissionFundingModel data;
  final String? campaignId;

  MissionFundingLoaded(this.data, this.campaignId);
}

class MissionFundingError extends MissionFundingState {
  final String message;

  MissionFundingError(this.message);
}

// ------------------------------------------------------------
// CUBIT
// ------------------------------------------------------------
class MissionFundingCubit extends Cubit<MissionFundingState> {
  final Dio _dio = Dio();
  final String issueId;
  String? campaignId;
  bool bidAccepted = false;
  bool bidCompleted = false;
  bool hasUserPaid = false;
  MissionStatusResponse? milestoneResponseModel;

  IncidentReport? incidentReport;

  MissionFundingCubit(this.issueId) : super(MissionFundingInitial()) {
    loadMission(issueId);
  }

  Future<void> loadMission(String issueId) async {
    emit(MissionFundingLoading());

    ///Get campaign id from issue id


    final incidentUrl = "http://3.109.152.78:8080/api/v1/issues/$issueId";
    final vendorUrl = "http://3.109.152.78:8080/api/v1/bids/issue/$issueId";
    final contributorUrl =
        "http://3.109.152.78:8080/api/v1/crowdfunding/campaigns/issue/$issueId";
    final milestoneUrl =
        "http://3.109.152.78:8080/api/v1/milestones/issue/$issueId";

    final incidentResponse = await _dio.get(incidentUrl);
    final vendorResponse = await _dio.get(vendorUrl);
    final contributorResponse = await _dio.get(contributorUrl);
    final milestoneResponse = await _dio.get(milestoneUrl);

    incidentReport = IncidentReport.fromJson(
      incidentResponse.data,
    );
    VendorBidsResponse? vendorBidsResponse = VendorBidsResponse.fromJson(
      vendorResponse.data,
    );

    if(vendorBidsResponse != null){
      bidAccepted = vendorBidsResponse.data.content.any((element) => element.status.compareTo("ACCEPTED") == 0 || element.status.compareTo("PAID") == 0);
      bidCompleted = vendorBidsResponse.data.content.any((element) => element.status.compareTo("PAID") == 0);
    }

    milestoneResponseModel = MissionStatusResponse.fromJson(milestoneResponse.data);
    CampaignFundingResponse? campaignFundingResponse =
        CampaignFundingResponse.fromJson(contributorResponse.data);
    campaignId = campaignFundingResponse.data.id;
    final String myUserId = (await SharedPreferences.getInstance()).getString(
      'userId',
    )!;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    hasUserPaid = campaignFundingResponse.data.contributors.any((contributor) => contributor.userId.toString().compareTo(sharedPreferences.getString("userId") ?? "0") == 0);

    try {
      final model = MissionFundingModel(
        title: incidentReport!.title,
        location: incidentReport!.address,
        headerImage: incidentReport!.imageUrls.first,
        isMe: incidentReport!.reporterName.compareTo(myUserId) == 0,
        totalAmount: (incidentReport!.ai!.estimatedBudget ?? 0.0).toInt(),
        currentPaid: campaignFundingResponse.data.amountCollected.toInt(),
        heroesList: campaignFundingResponse.data.contributors
            .map(
              (contributor) => HeroContributor(
                name: contributor.firstName + " " + contributor.lastName,
                imageUrl: 'https://i.pravatar.cc/150?img=60',
                amount: contributor.contributionAmount.toInt(),
              ),
            )
            .toList(),
        vendorBids: vendorBidsResponse.data.content
            .map(
              (content) => VendorBid(
                vendorName: content.serviceProviderName,
                avatar: 'https://i.pravatar.cc/150?img=60',
                proposedAmount: content.bidAmount,
                timeline: content.expectedTimeOfCompletion,
                rating: 4.9,
                reviews: 100,
                status: content.status,
                materialUsed: content.primaryMaterialUsed,
                whyChooseMe: content.whyChooseTeam,
                id: content.id,
              ),
            )
            .toList(),
      );

      // await Future.delayed(const Duration(milliseconds: 600));

      emit(MissionFundingLoaded(model, campaignId));
    } catch (e) {
      emit(MissionFundingError("Failed to load mission"));
    }
  }
}
