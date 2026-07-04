/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]
library;

import 'package:flutter_grocery/helper/html_string_checker.dart';

class ErrorResponseModel {
  List<Errors>? _errors;

  List<Errors>? get errors => _errors;

  ErrorResponseModel({List<Errors>? errors}) {
    _errors = _withFallback(errors);
  }

  ErrorResponseModel.fromJson(dynamic json) {
    final List<Errors> parsedErrors = [];

    if (json is Map) {
      final dynamic errors = json["errors"];
      if (errors is List) {
        parsedErrors.addAll(errors.map(Errors.fromJson));
      } else if (errors != null) {
        parsedErrors.add(Errors.fromJson(errors));
      } else if (json["message"] != null) {
        parsedErrors.add(
          Errors(
            code: json["code"]?.toString(),
            message: json["message"].toString(),
          ),
        );
      }
    } else if (json is List) {
      parsedErrors.addAll(json.map(Errors.fromJson));
    } else if (json is String) {
      if (!isHtmlResponse(json)) {
        parsedErrors.add(Errors(message: json));
      }
    } else if (json != null) {
      final message = json.toString();
      if (!isHtmlResponse(message)) {
        parsedErrors.add(Errors(message: message));
      }
    }

    _errors = _withFallback(parsedErrors);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_errors != null) {
      map["errors"] = _errors!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static List<Errors> _withFallback(List<Errors>? errors) {
    if (errors != null && errors.isNotEmpty) {
      return errors;
    }

    return [Errors(code: '', message: 'Unexpected error occurred')];
  }
}

/// code : "l_name"
/// message : "The last name field is required."

class Errors {
  String? _code;
  String? _message;

  String? get code => _code;
  String? get message => _message;

  Errors({String? code, String? message}) {
    _code = code;
    _message = message;
  }

  Errors.fromJson(dynamic json) {
    if (json is Map) {
      _code = json["code"]?.toString();
      final String? rawMessage =
          json["message"]?.toString() ?? json.toString();
      _message = isHtmlResponse(rawMessage) ? null : rawMessage;
    } else {
      _code = '';
      final String? rawMessage = json?.toString();
      _message = isHtmlResponse(rawMessage) ? null : rawMessage;
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    return map;
  }
}
