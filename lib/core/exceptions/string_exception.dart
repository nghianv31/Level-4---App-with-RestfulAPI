import 'package:api_demo/core/exceptions/api_exception.dart';
import 'package:api_demo/core/values/app_strings.dart';

class StringException {
  static String removeException(String error) {
    return error.replaceFirst('Exception: ', '');
  }

  static String messageException(ApiExceptionType type) {
    switch (type) {
      case ApiExceptionType.jsonParsingError:
        return AppStrings.jsonParsingError;
      case ApiExceptionType.usernameValidationError:
        return AppStrings.usernameValidationError;
      case ApiExceptionType.validationError:
        return AppStrings.validationError;
      case ApiExceptionType.conflictError:
        return AppStrings.conflictError;
      case ApiExceptionType.referenceError:
        return AppStrings.referenceError;
      case ApiExceptionType.missingHeader:
        return AppStrings.missingHeader;
      case ApiExceptionType.invalidHeaderFormat:
        return AppStrings.invalidHeaderFormat;
      case ApiExceptionType.invalidOrExpiredToken:
        return AppStrings.loginAgain;
      case ApiExceptionType.invalidCredentials:
        return AppStrings.loginFailed;
      case ApiExceptionType.resourceNotFound:
        return AppStrings.resourceNotFound;
      case ApiExceptionType.serverError:
        return AppStrings.errorServer;
      case ApiExceptionType.unknown:
        return AppStrings.unknown;
      case ApiExceptionType.locked:
        return AppStrings.lockLogin;
    }
  }
}