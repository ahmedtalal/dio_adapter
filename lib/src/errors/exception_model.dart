class ServerException implements Exception {
  final dynamic message;

  const ServerException(this.message);
}

class FetchDataException extends ServerException {
  const FetchDataException(super.message);
}

class BadRequestException extends ServerException {
  const BadRequestException(super.message);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.message);
}

class NotFoundException extends ServerException {
  const NotFoundException(super.message);
}

class ForbiddenException extends ServerException {
  const ForbiddenException(message) : super('Forbidden');
}

class ConflictException extends ServerException {
  const ConflictException(message) : super('Conflict');
}

class UnProcessableEntityException extends ServerException {
  const UnProcessableEntityException(super.message);
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException(super.message);
}

class NoInternetException extends ServerException {
  const NoInternetException(super.message);
}

class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});

  @override
  String toString() => '$message';
}