import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

class MemberRepo {
  final DioClient? dioClient;

  MemberRepo({required this.dioClient});

  Future<ApiResponseModel> getMatrixStatus() async {
    try {
      final response = await dioClient!.get(AppConstants.matrixStatusUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getMatrixTeam() async {
    try {
      final response = await dioClient!.get(AppConstants.matrixTeamUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getMatrixTree({int depth = 2}) async {
    try {
      final response = await dioClient!.get('${AppConstants.matrixTreeUri}?depth=$depth');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getMatrixIncentiveHistory() async {
    try {
      final response = await dioClient!.get(AppConstants.matrixIncentiveHistoryUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getMatrixLevels() async {
    try {
      final response = await dioClient!.get(AppConstants.matrixLevelsUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> transferPoints({required int toUserId, required int amount}) async {
    try {
      final response = await dioClient!.post(AppConstants.transferPointsUri, data: {'to_user_id': toUserId, 'amount': amount});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
