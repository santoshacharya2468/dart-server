import 'dart:async';

import 'package:dartserver/src/exception/http_exception.dart';
import 'package:dartserver/src/exception/i_exception_filter.dart';
import 'package:dartserver/src/response/http_response.dart';

class UnCaughtExceptionFilter implements IExceptionFilter {
  @override
  FutureOr<HttpResult> onException(ctx, exception) {
    return HttpResult.internalServerError({
      "error": exception is HttpServerException
          ? exception.data
          : exception.toString(),
      "date": DateTime.now().toString()
    });
  }
}
