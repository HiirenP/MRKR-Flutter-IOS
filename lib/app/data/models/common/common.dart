class ApiResponse {
  const ApiResponse({
    required this.version,
    required this.statusCode,
    required this.isSuccess,
    required this.message,
  });

  final String version;
  final num statusCode;
  final bool isSuccess;
  final String message;
}
