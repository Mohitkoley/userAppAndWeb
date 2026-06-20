import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/error_response_model.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorResponseModel', () {
    test('parses API error lists', () {
      final model = ErrorResponseModel.fromJson({
        'errors': [
          {'code': '401', 'message': 'Unauthorized'},
        ],
      });

      expect(model.errors!.first.code, '401');
      expect(model.errors!.first.message, 'Unauthorized');
    });

    test('uses plain strings as error messages', () {
      final model = ApiCheckerHelper.getError(
        ApiResponseModel.withError(
          'Receive timeout in connection with API server',
        ),
      );

      expect(
        model.errors!.first.message,
        'Receive timeout in connection with API server',
      );
    });

    test('provides a fallback for null and malformed errors', () {
      expect(ErrorResponseModel.fromJson(null).errors, isNotEmpty);
      expect(ErrorResponseModel.fromJson({'errors': []}).errors, isNotEmpty);
    });
  });
}
