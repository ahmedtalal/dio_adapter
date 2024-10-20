// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:dio/dio.dart';
import 'package:dio_adapter/src/errors/status_code.dart';
import 'exception_model.dart';

const _connectionTimeoutError = 'connectionTimeoutError';
const _noInternetConnection = 'noInternetConnection';
const _internalServerError = 'internal server error';
const _undefineError = 'undefine error';

ServerException handleDioError(DioException error) {
  ServerException? serverException;
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      serverException = const FetchDataException(_connectionTimeoutError);
    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case StatusCode.badRequest:
          serverException = BadRequestException(error.message.toString());
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          serverException = UnauthorizedException(error.message.toString());
        case StatusCode.notFound:
          serverException = NotFoundException(error.message.toString());
        case StatusCode.conflict:
          serverException = ConflictException(error.message.toString());
        case StatusCode.unProcessableEntity:
          serverException =
              UnProcessableEntityException(error.message.toString());
        case StatusCode.internalServerError:
          serverException = InternalServerErrorException(_internalServerError);
        default:
          serverException = const FetchDataException(_connectionTimeoutError);
      }
    case DioExceptionType.cancel:
      break;
    case DioExceptionType.unknown:
      serverException = const NoInternetException(_noInternetConnection);
    case DioExceptionType.badCertificate:
      serverException = const NoInternetException(_noInternetConnection);
    case DioExceptionType.connectionError:
      serverException = const NoInternetException(_noInternetConnection);
    default:
      serverException = const ServerException(_undefineError);
  }
  return serverException!;
}
