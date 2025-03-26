import 'dart:async';

import 'package:dartserver/src/exception/i_exception_filter.dart';
import 'package:dartserver/src/request/request.dart';
import 'package:dartserver/src/response/http_response.dart';

import 'app_error.dart';

class AppExceptionFilter implements IExceptionFilter {
  @override
  FutureOr<HttpResult?> onException(RequestContext context, Exception e) {
    if (e is AppError) {
      return HttpResult.badRequest(e.message);
    }
    return null;
  }
}
