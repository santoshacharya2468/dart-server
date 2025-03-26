import 'dart:convert';

import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/router/http_method.dart';

extension HttpRequestContextExtension on RequestContext {
  String get path => request.uri.path;
  Map<String, dynamic> get queryParams {
    final queryString = request.uri.query;
    if (queryString.isEmpty) return {};

    return queryString.split('&').fold<Map<String, dynamic>>({}, (map, pair) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
      return map;
    });
  }

  //get path params
  Map<String, dynamic> get pathParams {
    final pathParams = <String, dynamic>{};
    final routePattern = pattern;
    final actualPath = path;
    final patternParts = routePattern.split('/');
    final pathParts = actualPath.split('/');
    for (int i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        final paramName = patternParts[i].substring(1);
        pathParams[paramName] = pathParts[i];
      }
    }

    return pathParams;
  }

  String? pathParam(String key) {
    return pathParams[key];
  }

  int? pathParamInt(String key) {
    return int.tryParse(pathParams[key] ?? "");
  }

  String? query(String key) {
    return queryParams[key];
  }

  Future<Map<String, dynamic>> get jsonBody async {
    try {
      final content = utf8.decode(await request.single);
      if (content.isEmpty) return {};
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<T> bodyJson<T>(T Function(Map<String, dynamic> json) func) async {
    final json = await jsonBody;
    return func(json);
  }

  HttpMethod get method => HttpMethod.values
      .firstWhere((element) => element.name == request.method.toLowerCase());
}
