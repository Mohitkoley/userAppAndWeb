import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/error_response_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/html_string_checker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiCheckerHelper {
  static bool _isOnDashboard() {
    final context = Get.context;
    if (context == null) return false;

    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName != RouteHelper.menu) return false;

    return Provider.of<SplashProvider>(context, listen: false).pageIndex == 0;
  }

  static void checkApi(ApiResponseModel apiResponse, {bool showErrorSnackBar = true}) {
    ErrorResponseModel error = getError(apiResponse);
    final Errors firstError = error.errors!.first;
    final bool isUnauthorized =
        firstError.code == '401' || firstError.code == 'auth-001';
    final bool isLoginRoute =
        ModalRoute.of(Get.context!)?.settings.name == RouteHelper.login;

    if (isUnauthorized && !isLoginRoute) {
      Provider.of<SplashProvider>(
        Get.context!,
        listen: false,
      ).removeSharedData();
      Provider.of<SplashProvider>(Get.context!, listen: false).setPageIndex(0);
      RouteHelper.getLoginRoute(action: RouteAction.push);
    } else if (showErrorSnackBar && !_isOnDashboard()) {
      final String? message = firstError.message;
      final String? code = firstError.code;
      final bool isHttpStatusError =
          code != null && int.tryParse(code) != null;

      if (message == null ||
          message.isEmpty ||
          isHtmlResponse(message) ||
          message.length > 200 ||
          isHttpStatusError) {
        return;
      }
      showCustomSnackBarHelper(getTranslated(message, Get.context!));
    }
  }

  static ErrorResponseModel getError(ApiResponseModel apiResponse) {
    return ErrorResponseModel.fromJson(apiResponse.error);
  }

  static Future<String> getStreamedResponseError(
    http.StreamedResponse response,
  ) async {
    String errorMessage = '${response.statusCode} ${response.reasonPhrase}';

    try {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(responseBody);

      ErrorResponseModel errorResponse = ErrorResponseModel.fromJson(
        responseMap,
      );

      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        errorMessage = errorResponse.errors!.first.message ?? errorMessage;
      }
    } catch (e) {
      debugPrint('Error parsing response: $e');
    }

    return errorMessage;
  }
}
