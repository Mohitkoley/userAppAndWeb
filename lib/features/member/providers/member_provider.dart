import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/features/member/domain/models/member_matrix_model.dart';
import 'package:flutter_grocery/features/member/domain/reposotories/member_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';

class MemberProvider with ChangeNotifier {
  final MemberRepo? memberRepo;

  MemberProvider({required this.memberRepo});

  bool _isLoading = false;
  MatrixStatusModel? _matrixStatus;
  MatrixTeamModel? _matrixTeam;
  MatrixTreeNodeModel? _matrixTree;
  MatrixIncentiveHistoryModel? _incentiveHistory;
  List<MatrixLevelModel> _levels = [];

  bool get isLoading => _isLoading;
  MatrixStatusModel? get matrixStatus => _matrixStatus;
  MatrixTeamModel? get matrixTeam => _matrixTeam;
  MatrixTreeNodeModel? get matrixTree => _matrixTree;
  MatrixIncentiveHistoryModel? get incentiveHistory => _incentiveHistory;
  List<MatrixLevelModel> get levels => _levels;

  Future<void> getMemberDashboard({
    bool reload = false,
    bool isUpdate = true,
  }) async {
    if (_matrixStatus != null && !reload) {
      return;
    }

    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }

    await Future.wait([
      _getMatrixStatus(),
      _getMatrixTeam(),
      _getMatrixTree(),
      _getIncentiveHistory(),
      _getMatrixLevels(),
    ]);

    _isLoading = false;
    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<void> _getMatrixStatus() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixStatus();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _matrixStatus = MatrixStatusModel.fromJson(
        Map<String, dynamic>.from(apiResponse.response!.data),
      );
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixTeam() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixTeam();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _matrixTeam = MatrixTeamModel.fromJson(
        Map<String, dynamic>.from(apiResponse.response!.data),
      );
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixTree() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixTree();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _matrixTree = MatrixTreeNodeModel.fromJson(
        Map<String, dynamic>.from(apiResponse.response!.data),
      );
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getIncentiveHistory() async {
    ApiResponseModel apiResponse = await memberRepo!
        .getMatrixIncentiveHistory();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _incentiveHistory = MatrixIncentiveHistoryModel.fromJson(
        Map<String, dynamic>.from(apiResponse.response!.data),
      );
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<void> _getMatrixLevels() async {
    ApiResponseModel apiResponse = await memberRepo!.getMatrixLevels();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final dynamic responseData = apiResponse.response!.data;
      final List rawList = responseData is List
          ? responseData
          : responseData is Map
          ? responseData['data'] ?? []
          : [];
      _levels = rawList
          .map(
            (item) =>
                MatrixLevelModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }
}
