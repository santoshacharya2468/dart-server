class HttpServerException implements Exception {
  final int statusCode;
  final String? data;

  HttpServerException({required this.statusCode, this.data});
}

class NotFoundException extends HttpServerException {
  NotFoundException([String? data]) : super(statusCode: 404, data: data);
}

class UnAuthorizedException extends HttpServerException {
  UnAuthorizedException([String? data]) : super(statusCode: 401, data: data);
}

class BadRequestException extends HttpServerException {
  BadRequestException([String? data]) : super(statusCode: 400, data: data);
}

class ForbiddenException extends HttpServerException {
  ForbiddenException([String? data]) : super(statusCode: 403, data: data);
}

class InternalServerErrorException extends HttpServerException {
  InternalServerErrorException([String? data])
      : super(statusCode: 500, data: data);
}

class ServiceUnavailableException extends HttpServerException {
  ServiceUnavailableException([String? data])
      : super(statusCode: 503, data: data);
}
