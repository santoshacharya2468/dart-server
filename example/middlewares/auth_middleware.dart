import 'dart:async';

import 'package:dartserver/dartserver.dart';

class AuthMiddleware implements IHttpRequestMiddleware {
  @override
  FutureOr<bool> handle(RequestContext ctx) {
    final username = ctx.query("token");
    if (username?.isNotEmpty == true) {
      ctx.setLocal("user", username);
      return false;
    }
    ctx.sendStatus(401, message: "Invalid Token");
    return true;
  }
}

class IsAuthAdminMiddleware implements IHttpRequestMiddleware {
  @override
  FutureOr<bool> handle(RequestContext ctx) {
    final username = ctx.query("admin");
    if (username?.isNotEmpty == true) {
      ctx.setLocal("user", username);
      return false;
    }
    ctx.sendStatus(403, message: "Forbidden resource");
    return true;
  }
}
