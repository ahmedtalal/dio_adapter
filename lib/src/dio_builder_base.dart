import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_builder/src/dio_helper/api_curds.dart';
import 'package:dio_builder/src/dio_helper/api_interceptor.dart';
import 'package:dio_builder/src/errors/exception_model.dart';
import 'package:dio_builder/src/errors/handel_dio_errors.dart';
import 'package:either_dart/either.dart';

class DioBuilderBase implements IApiCurds<Either<String, Response>> {
  final String baseUrl;
  final RequestOptions Function(RequestOptions options)? customRequestHandler;
  final Response Function(Response response)? customResponseHandler;
  final void Function(DioException error)? customErrorHandler;
  final String contentType;
  final Duration connectTimeout, receiveTimeout;
  final ResponseType responseType;
  DioBuilderBase({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.responseType,
    required this.contentType,
    required this.customRequestHandler,
    required this.customResponseHandler,
    required this.customErrorHandler,
  }) {
    _init();
    _httpAdapter();
    _detectInterceptor();
  }
  Dio? _dioClient;

  /// this function to initialize dio package
  _init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      responseType: responseType,
      contentType: contentType,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    _dioClient = Dio(options);
  }

  /// this function to adapt http protocol
  _httpAdapter() {
    _dioClient!.httpClientAdapter = IOHttpClientAdapter(
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
  /// prettyDioLogger to logs network calls in a pretty, easy to read format.
  _detectInterceptor() {
    _dioClient!.interceptors.add(CustomInterceptors(
      customRequestHandler: customRequestHandler,
      customResponseHandler: customResponseHandler,
      customErrorHandler: customErrorHandler,
    ));
  }

  @override
  Future<Either<String, Response>> delete(String path,
      {Map<String, dynamic>? queryParameters, options}) async {
    try {
      final response =
          await _dioClient!.delete(path, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> get(String path,
      {Map<String, dynamic>? queryParameters, options}) async {
    try {
      final response =
          await _dioClient!.get(path, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> post(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? body,
      options}) async {
    try {
      final response = await _dioClient!
          .post(path, data: body, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Response>> put(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? body,
      options}) async {
    try {
      final response = await _dioClient!
          .put(path, data: body, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (error) {
      ServerException serverException = handleDioError(error);
      return Left(serverException.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
