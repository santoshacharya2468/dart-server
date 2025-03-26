abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

class HttpResult {
  final dynamic data;
  final int statusCode;
  HttpResult({required this.data, required this.statusCode});
  HttpResult status(int statusCode) {
    return HttpResult(data: data, statusCode: statusCode);
  }

  static HttpResult ok<T extends JsonSerializable>(T data) {
    return HttpResult(data: data.toJson(), statusCode: 200);
  }

  static HttpResult created(dynamic data) {
    return HttpResult(data: data, statusCode: 201);
  }

  static HttpResult noContent() {
    return HttpResult(data: "", statusCode: 204);
  }

  static HttpResult text(String data, [int statusCode = 200]) {
    return HttpResult(data: data, statusCode: statusCode);
  }

  static HttpResult json(Map<String, dynamic> data, [int? statusCode]) {
    return HttpResult(data: data, statusCode: statusCode ?? 200);
  }

  static HttpResult notFound() {
    return HttpResult(data: "not found", statusCode: 404);
  }

  static HttpResult badRequest(dynamic data) {
    return HttpResult(data: data, statusCode: 400);
  }

  static HttpResult internalServerError(dynamic data) {
    return HttpResult(data: data, statusCode: 500);
  }

  static HttpResult unauthorized(dynamic data) {
    return HttpResult(data: data, statusCode: 401);
  }
}
