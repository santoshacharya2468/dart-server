import 'dart:io';
import 'package:dartserver/dartserver.dart';
import 'package:dartserver/src/exception/http_exception.dart';
import 'package:dartserver/src/exception/uncaught_exception_filter.dart';
import 'dart:async' show Future, unawaited;
import 'package:dartserver/src/router/http_method.dart';

class DartleServer {
  HttpServer? _server;

  Route? _findRoute(String path, HttpMethod method, Router router) {
    final routes = router.routes;
    // First check in current router
    var route = routes.firstWhereOrNull((element) =>
        element.path == path &&
        (element.method == method || element.method == HttpMethod.all));
    if (route != null) return route;

    // Try pattern matching for dynamic routes
    return routes.firstWhereOrNull((element) {
      if (element.method != method && element.method != HttpMethod.all) {
        return false;
      }
      final routeParts = element.path.split('/');
      final requestParts = path.split('/');
      if (routeParts.length != requestParts.length) return false;

      for (var i = 0; i < routeParts.length; i++) {
        final routePart = routeParts[i];
        final requestPart = requestParts[i];

        // Check if it's a parameter (starts with :)
        if (routePart.startsWith(':')) continue;
        if (routePart != requestPart) return false;
      }

      return true;
    });
  }

  Future<void> start({
    String host = 'localhost',
    required int port,
    required Router router,
  }) async {
    _server = await HttpServer.bind(
      host,
      port,
    );
    print('Server listening on $host:$port');
    await for (HttpRequest request in _server!) {
      // Handle each request in a separate Future
      unawaited(_handleRequest(request, router));
    }
  }

  Future<void> _handleRequest(HttpRequest request, Router router) async {
    final context = RequestContext.internal(request: request, pattern: "");
    final path = context.path;
    final method = context.method;
    final route = _findRoute(path, method, router);
    final handler = route?.handler;
    try {
      if (handler != null) {
        context.pattern = route!.path;
        bool rejectionFromMiddleware = false;
        for (var middleware in route.middlewares) {
          rejectionFromMiddleware = await middleware.handle(context);
          if (rejectionFromMiddleware) break;
        }
        if (rejectionFromMiddleware) return;
        final response = await handler(context);
        context.json(response.data, statusCode: response.statusCode);
      } else {
        throw NotFoundException("route not found");
      }
    } on Exception catch (e) {
      final exceptionFilters = route?.exceptionFilters ?? [];
      exceptionFilters.add(UnCaughtExceptionFilter());
      for (var filter in exceptionFilters) {
        final response = await filter.onException(context, e);
        if (response != null) {
          context.sendStatus(response.statusCode,
              message: response.data.toString());
          break;
        }
      }
    }
  }
}
