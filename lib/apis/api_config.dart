class ApiConfig {
  static const String baseUrl = "https://ikoncloud-dev.keross.com/";
  static const String baseApiUrl = "$baseUrl/rest";
  static const String uploadUrl = "$baseUrl/upload";
  static const String downloadUrl = "$baseUrl/download";
  static const String uaResourceUpload = "$baseUrl/uaresourceupload";
  static const String uaResourceUrl = "$baseUrl/portal/uaresource";

  // Method to get WebSocket URL instead of const
  static String getWsUrl() {
    final uri = Uri.parse(baseUrl);
    final wsProtocol = uri.scheme == "https" ? "wss" : "ws";
    return "$wsProtocol://${uri.host}/realtime";
  }
}