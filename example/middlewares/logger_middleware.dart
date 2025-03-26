import 'dart:async';

import 'package:dartserver/dartserver.dart';

class LoggerMiddleware implements IHttpRequestMiddleware {
  @override
  FutureOr<bool> handle(RequestContext ctx) {
    print("${ctx.request.method} ${ctx.request.uri}");
    return false;
  }
}
