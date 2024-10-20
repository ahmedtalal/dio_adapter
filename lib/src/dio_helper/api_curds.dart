import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class IApiCurds {
  Future<Either<String, Response>> get(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  });
  Future<Either<String, Response>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  });
  Future<Either<String, Response>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
  Future<Either<String, Response>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  });
}
