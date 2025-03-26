import 'package:dartserver/src/exception/i_exception_filter.dart';
import 'package:dartserver/src/router/http_method.dart';
import 'package:dartserver/src/server/server_plugin.dart';

import '../../dartserver.dart';

class Route {
  final HttpMethod method;
  String path;
  final RequestHandler handler;
  List<IServerPlugIn>? plugIns;
  List<IHttpRequestMiddleware> get middlewares =>
      plugIns?.whereType<IHttpRequestMiddleware>().toList() ?? [];
  List<IExceptionFilter> get exceptionFilters =>
      plugIns?.whereType<IExceptionFilter>().toList() ?? [];

  Route({
    required this.method,
    required this.path,
    required this.handler,
  });
  Route use(IServerPlugIn plugIn) {
    plugIns ??= [];
    plugIns?.add(plugIn);
    return this;
  }
}
