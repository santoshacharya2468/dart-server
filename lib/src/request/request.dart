import 'dart:convert';
import 'dart:io';

class RequestContext {
  final Map<String, dynamic> _locals = {};
  final HttpRequest request;
  String pattern = "";
  RequestContext.internal({required this.request, required this.pattern});
  bool json(Map json, {int statusCode = 200}) {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(json));
    request.response.close();
    return true;
  }

  bool send(String content) {
    request.response.write(content);
    request.response.close();
    return true;
  }

  bool sendStatus(int statusCode, {String? message}) {
    request.response.statusCode = statusCode;
    request.response.write(message);
    request.response.close();
    return true;
  }

  bool setLocal(String key, dynamic value) {
    _locals[key] = value;
    return true;
  }

  T getLocal<T>(String key) {
    return _locals[key] as T;
  }
}
