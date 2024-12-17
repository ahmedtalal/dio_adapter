import 'package:dio/dio.dart';
import 'package:dio_adapter/src/errors/status_code.dart';
import 'exception_model.dart';

const String _connectionTimeoutError = 'connectionTimeoutError';
const String _noInternetConnection = 'noInternetConnection';
const String _internalServerError = 'internal server error';
const String _undefinedError = 'undefined error';
const String _cancelRequestError = 'Request was cancelled';

ServerException handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const FetchDataException(_connectionTimeoutError);

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final errorMessage = error.message.toString();

      switch (statusCode) {
        case StatusCode.badRequest:
          return BadRequestException(errorMessage);
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          return UnauthorizedException(errorMessage);
        case StatusCode.notFound:
          return NotFoundException(errorMessage);
        case StatusCode.conflict:
          return ConflictException(errorMessage);
        case StatusCode.unProcessableEntity:
          return UnProcessableEntityException(errorMessage);
        case StatusCode.internalServerError:
          return InternalServerErrorException(_internalServerError);
        default:
          return const FetchDataException(_connectionTimeoutError);
      }

    case DioExceptionType.cancel:
      return ServerException(_cancelRequestError);

    case DioExceptionType.unknown:
    case DioExceptionType.badCertificate:
    case DioExceptionType.connectionError:
      return const NoInternetException(_noInternetConnection);

    // default:
    //   return const ServerException(_undefinedError);
  }
}
