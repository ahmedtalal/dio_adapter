import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_adapter/src/dio_helper/api_curds.dart';
import 'package:dio_adapter/src/dio_helper/api_interceptor.dart';
import 'package:dio_adapter/src/dio_helper/response_types.dart';
import 'package:dio_adapter/src/errors/exception_model.dart';
import 'package:dio_adapter/src/errors/handel_dio_errors.dart';
import 'package:either_dart/either.dart';

class DioAdapterBase implements IApiCurds {
  final String baseUrl;
  final Future<RequestOptions> Function(RequestOptions options)? customRequestHandler;
  final Future<Response> Function(Response response)? customResponseHandler;
  final Future<DioException> Function(DioException error)? customErrorHandler;
  final String contentType;
  final Duration connectTimeout, receiveTimeout;
  final ResponseTypeEnum responseTypeEnum;
  DioAdapterBase({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.contentType,
    required this.customRequestHandler,
    required this.customResponseHandler,
    required this.customErrorHandler,
    required this.responseTypeEnum,
  }) {
    _init();
    _httpAdapter();
    _detectInterceptor();
  }
  final Dio _dioClient = Dio();

  /// is used to detect the type of response and return it
  ResponseType _detectResponseType() {
    switch (responseTypeEnum) {
      case ResponseTypeEnum.json:
        return ResponseType.json;
      case ResponseTypeEnum.bytes:
        return ResponseType.bytes;
      case ResponseTypeEnum.stream:
        return ResponseType.stream;
      case ResponseTypeEnum.plain:
        return ResponseType.plain;
      default:
        return ResponseType.json;
    }
  }

  /// this function to initialize dio package
  _init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      responseType: _detectResponseType(),
      contentType: contentType,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    _dioClient.options = options;
  }

  /// this function to adapt http protocol
  _httpAdapter() {
    _dioClient.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
        return client;
      },
    );
  }

  /// this function to add interceptor to dio client
  _detectInterceptor() {
    _dioClient.interceptors.add(CustomInterceptors(
      customRequestHandler: customRequestHandler,
      customResponseHandler: customResponseHandler,
      customErrorHandler: customErrorHandler,
    ));
  }

  @override
  Future<Either<String, Response>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> get(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dioClient.get(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dioClient.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _dioClient.put(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
