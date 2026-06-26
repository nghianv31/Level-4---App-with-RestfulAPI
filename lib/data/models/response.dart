class SuccessResponse {
  bool success;
  dynamic data;

  SuccessResponse({required this.success, required this.data});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      success: json['success'],
      data: json['data'],
    );
  }
}

class ErrorResponse {
  bool success;
  String error;

  ErrorResponse({required this.success, required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'],
      error: json['error'],
    );
  }
}