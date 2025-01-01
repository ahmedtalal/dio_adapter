import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
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
  final Future<RequestOptions> Function(
          RequestOptions options, RequestInterceptorHandler handler)?
      customRequestHandler;
  final Future<Response> Function(
          Response response, ResponseInterceptorHandler handler)?
      customResponseHandler;
  final Future<DioException> Function(
      DioException error, ErrorInterceptorHandler handler)? customErrorHandler;
  final ContentTypeEnum contentTypeEnum;
  final Duration connectTimeout, receiveTimeout;
  final ResponseTypeEnum responseTypeEnum;
  final String? sslCertificateSHa256;
  DioAdapterBase({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.contentTypeEnum,
    required this.customRequestHandler,
    required this.customResponseHandler,
    required this.customErrorHandler,
    required this.responseTypeEnum,
    required this.sslCertificateSHa256,
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
      // default:
      //   return ResponseType.json;
    }
  }

  /// is used to detect the type of request content and return it
  String _detectContentType() {
    switch (contentTypeEnum) {
      case ContentTypeEnum.applicationJson:
        return 'application/json';
      case ContentTypeEnum.applicationXml:
        return 'application/xml';
      case ContentTypeEnum.textPlain:
        return 'text/plain';
      case ContentTypeEnum.applicationXWwwFormUrlencoded:
        return 'application/x-www-form-urlencoded';
      case ContentTypeEnum.multipartFormData:
        return 'multipart/form-data';
      case ContentTypeEnum.applicationOctetStream:
        return 'application/octet-stream';
    }
  }

  /// this function to initialize dio package
  _init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      responseType: _detectResponseType(),
      contentType: _detectContentType(),
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
          if (sslCertificateSHa256 != null) {
            // 1. Extract the server certificate in DER format (binary)
            final Uint8List der = cert.der;
            // 2. Calculate the SHA-256 fingerprint of the certificate
            final String serverFingerprint = _sha256Digest(der);
            // 3. Compare with the expected (trusted) fingerprint
            final String expectedFingerprint = sslCertificateSHa256!;
            // 4. Return true if they match, false otherwise
            return serverFingerprint == expectedFingerprint;
          }
          return true;
        };
        return client;
      },
    );
  }

  /// Function to compute the SHA-256 digest of a certificate
  String _sha256Digest(Uint8List data) {
    final digest = sha256.convert(data); // Calculate SHA-256
    return base64.encode(digest.bytes); // Encode the hash in Base64
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
