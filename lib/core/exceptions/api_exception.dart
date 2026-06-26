import 'package:api_demo/data/models/response.dart';

enum ApiExceptionType {
  // 400 Bad Request
  jsonParsingError,
  usernameValidationError,
  validationError,
  conflictError,
  referenceError,

  // 401 Unauthorized
  missingHeader,
  invalidHeaderFormat,
  invalidOrExpiredToken,
  invalidCredentials,

  // 404 Not Found
  resourceNotFound,

  // 500 Internal Server Error
  serverError,

  // Fallback
  unknown,
  locked,
}

class ApiException implements Exception {
  final int? statusCode;
  final String errorText;
  final ApiExceptionType type;

  ApiException({
    this.statusCode,
    required this.errorText,
    required this.type,
  });

  factory ApiException.fromResponse(int? statusCode, dynamic data) {
    String errorMsg = '';
    if (data is Map<String, dynamic>) {
      try {
        final errResp = ErrorResponse.fromJson(data);
        errorMsg = errResp.error;
      } catch (_) {
        errorMsg = data['error']?.toString() ?? data.toString();
      }
    } else {
      errorMsg = data?.toString() ?? 'Unknown error';
    }

    ApiExceptionType type = ApiExceptionType.unknown;

    if (statusCode == 400) {
      if (errorMsg.contains('Invalid request body')) {
        type = ApiExceptionType.jsonParsingError;
      } else if (errorMsg.contains('username must be')) {
        type = ApiExceptionType.usernameValidationError;
      } else if (errorMsg.contains('validation error')) {
        type = ApiExceptionType.validationError;
      } else if (errorMsg.contains('already exists')) {
        type = ApiExceptionType.conflictError;
      } else if (errorMsg.contains('does not exist')) {
        type = ApiExceptionType.referenceError;
      } else {
        type = ApiExceptionType.validationError;
      }
    } else if (statusCode == 401) {
      if (errorMsg.contains('Missing Authorization')) {
        type = ApiExceptionType.missingHeader;
      } else if (errorMsg.contains('Invalid Authorization header format')) {
        type = ApiExceptionType.invalidHeaderFormat;
      } else if (errorMsg.contains('Invalid or expired access token')) {
        type = ApiExceptionType.invalidOrExpiredToken;
      } else if (errorMsg.contains('invalid username or password')) {
        type = ApiExceptionType.invalidCredentials;
      } else {
        type = ApiExceptionType.invalidCredentials;
      }
    } else if (statusCode == 404) {
      type = ApiExceptionType.resourceNotFound;
    } else if (statusCode != null && statusCode >= 500) {
      type = ApiExceptionType.serverError;
    }

    return ApiException(
      statusCode: statusCode,
      errorText: errorMsg,
      type: type,
    );
  }

  @override
  String toString() => errorText;
}
