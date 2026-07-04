import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/common/enums/app_mode_enum.dart';
import 'package:flutter_grocery/common/models/error_response_model.dart';
import 'package:flutter_grocery/helper/html_string_checker.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/app_constants.dart';



class ApiErrorHandler {
  static dynamic getMessage(dynamic error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;

            case DioExceptionType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 500:
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  final dynamic responseData = error.response!.data;
                  if (responseData is String && isHtmlResponse(responseData)) {
                    errorDescription = {
                      'errors': [
                        {
                          'code': '${error.response!.statusCode}',
                          'message': getTranslated(
                            'unavailable_to_process_data',
                            Get.context!,
                          ),
                        },
                      ],
                    };
                    break;
                  }

                  ErrorResponseModel? errorResponse;
                  try {
                    errorResponse = ErrorResponseModel.fromJson(responseData);
                  } catch (e) {
                    if (kDebugMode) {
                      print('error is -> ${e.toString()}');
                    }
                  }

                  if (errorResponse != null &&
                      errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty &&
                      !isHtmlResponse(errorResponse.errors!.first.message)) {
                    if (kDebugMode) {
                      print('error----------------== ${errorResponse.errors![0].message} || error: ${error.response!.requestOptions.uri}');
                    }
                    errorDescription = errorResponse.toJson();
                  } else {
                    errorDescription = {
                      'errors': [
                        {
                          'code': '${error.response!.statusCode}',
                          'message': getTranslated(
                            'unavailable_to_process_data',
                            Get.context!,
                          ),
                        },
                      ],
                    };
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = getTranslated('send_timeout_with_server', Get.context!);
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = getTranslated('send_timeout_with_server', Get.context!);

              break;
            case DioExceptionType.badCertificate:
              errorDescription = getTranslated('incorrect_certificate', Get.context!);

              break;
            case DioExceptionType.connectionError:
              errorDescription = '${getTranslated('unavailable_to_process_data', Get.context!)} ${ AppMode.demo == AppConstants.appMode
                  ? error.response?.requestOptions.path  : error.response?.statusCode}' ;

              break;
            case DioExceptionType.unknown:
              debugPrint('error----------------== ${error.response?.requestOptions.path} || ${error.response?.statusCode} ${error.response?.data}');

              errorDescription = getTranslated('unavailable_to_process_data', Get.context!);

              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
