import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/member/domain/models/member_matrix_model.dart';
import 'package:flutter_grocery/features/member/domain/reposotories/member_repo.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:provider/provider.dart';

class MemberProvider with ChangeNotifier {
  final MemberRepo? memberRepo;

  MemberProvider({required this.memberRepo});

  bool _isLoading = false;
  bool _isTransferLoading = false;
  MatrixStatusModel? _matrixStatus;
  MatrixTeamModel? _matrixTeam;
  MatrixTreeNodeModel? _matrixTree;
  MatrixIncentiveHistoryModel? _incentiveHistory;
  List<MatrixLevelModel> _levels = [];

  bool get isLoading => _isLoading;
  bool get isTransferLoading => _isTransferLoading;
  MatrixStatusModel? get matrixStatus => _matrixStatus;
  MatrixTeamModel? get matrixTeam => _matrixTeam;
  MatrixTreeNodeModel? get matrixTree => _matrixTree;
  MatrixIncentiveHistoryModel? get incentiveHistory => _incentiveHistory;
  List<MatrixLevelModel> get levels => _levels;

  Future<void> getMemberDashboard({bool reload = false, bool isUpdate = true}) async {
    if (_matrixStatus != null && !reload) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    await Future.wait([_getMatrixStatus(), _getMatrixTeam(), _getMatrixTree(), _getIncentiveHistory(), _getMatrixLevels()]);

    _isLoading = false;
    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<void> _getMatrixStatus() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixStatus();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _matrixStatus = MatrixStatusModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixTeam() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixTeam();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _matrixTeam = MatrixTeamModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixTree() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixTree();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _matrixTree = MatrixTreeNodeModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getIncentiveHistory() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixIncentiveHistory();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _incentiveHistory = MatrixIncentiveHistoryModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixLevels() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixLevels();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic responseData = apiResponse.response!.data;
      final List rawList = responseData is List
          ? responseData
          : responseData is Map
          ? responseData['data'] ?? []
          : [];
      _levels = rawList.map((item) => MatrixLevelModel.fromJson(Map<String, dynamic>.from(item))).toList();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<ResponseModel> transferPoints({required int toUserId, required int amount}) async {
    _isTransferLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await memberRepo!.transferPoints(toUserId: toUserId, amount: amount);
    ResponseModel responseModel;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final data = Map<String, dynamic>.from(apiResponse.response!.data);
      responseModel = ResponseModel(true, '${data['message'] ?? 'Points transferred successfully'}');
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo(true);
      await getMemberDashboard(reload: true, isUpdate: false);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
      responseModel = ResponseModel(false, '${apiResponse.error ?? 'Transfer failed'}');
    }

    _isTransferLoading = false;
    notifyListeners();
    return responseModel;
  }
}
