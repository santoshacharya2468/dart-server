import 'dart:async';

import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/response/responses.dart';

import '../router/user_router.dart';

class AuthMiddleware implements IHttpRequestMiddleware {
  @override
  FutureOr<HttpResult?> onRequest(RequestContext ctx) {
    final username = ctx.header("token");
    if (username?.isNotEmpty == true) {
      final user =
          users.firstWhereOrNull((element) => element.username == username);
      if (user != null) {
        ctx.setLocal("user", user);
        return null;
      }
      return HttpResult(data: "Invalid Username", statusCode: 401);
    }
    return HttpResult(data: "no token provided", statusCode: 401);
  }
}

class IsAuthAdminMiddleware implements IHttpRequestMiddleware {
  @override
  FutureOr<HttpResult?> onRequest(RequestContext ctx) {
    final user = ctx.getLocal<User?>("user");
    if (user != null && user.username == "admin") {
      return null;
    }
    return HttpResult(data: "forbidden resource", statusCode: 401);
  }
}
