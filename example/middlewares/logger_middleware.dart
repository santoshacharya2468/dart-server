import 'dart:async';

import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/responses.dart';

class LoggerMiddleware extends IHttpRequestMiddleware {
  @override
  FutureOr<HttpResult?> onRequest(RequestContext ctx) {
    print("${ctx.request.method} ${ctx.request.uri}");
    return null;
  }
}
