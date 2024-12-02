import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class CustomInterceptors extends Interceptor {
  final Future<RequestOptions> Function(
          RequestOptions options, RequestInterceptorHandler handler)?
      customRequestHandler;
  final Future<Response> Function(
          Response response, ResponseInterceptorHandler handler)?
      customResponseHandler;
  final Future<DioException> Function(
      DioException error, ErrorInterceptorHandler handler)? customErrorHandler;
  const CustomInterceptors({
    required this.customRequestHandler,
    required this.customResponseHandler,
    required this.customErrorHandler,
  });
  static final bool _isReleaseMode = bool.fromEnvironment('dart.vm.product');
  static final Logger _logger = Logger(
    level: _isReleaseMode
        ? Level.off
        : Level.debug, // Disable logs in release mode
  );
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    /// add custom request handler
    if (customRequestHandler != null) {
      options = await customRequestHandler!(options, handler);
    }

    dynamic data; // variable to store data
    /// Check if the content type is form-data
    if (options.headers['Content-Type'] == 'multipart/form-data') {
      if (options.data is FormData) {
        FormData formData = options.data as FormData;
        data = _formDataToMap(formData);
      }
    } else {
      data = options.data;
    }

    ///convert request to json
    var requestData = {
      'method': options.method,
      'url': options.uri.toString(),
      'headers': options.headers,
      'body': data
    };
    _logger
        .i("-----------------[ request ${options.uri} start ]---------------");
    _printPrettyJson(requestData, "the content of request is", "request");
    _logger.i("-----------------[ request ${options.uri} end ]---------------");
    handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    /// add custom response handler
    if (customResponseHandler != null) {
      response = await customResponseHandler!(response, handler);
    }
    _logger.i(
        "-----------------[ response of request ${response.requestOptions.uri} start ]---------------");

    ///convert request to json
    var requestData = {
      'method': response.requestOptions.method,
      'url': response.requestOptions.uri.toString(),
      'headers': response.headers,
      'body': response.data,
      'statusCode': response.statusCode
    };
    _printPrettyJson(requestData, "the content of response is ", "response");
    _logger.i(
        "-----------------[ response of request ${response.requestOptions.uri} end ]---------------");

    handler.next(response);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    /// add custom error handler
    if (customErrorHandler != null) {
      err = await customErrorHandler!(err, handler);
    }
    _logger.i(
        "-----------------[ error of request ${err.response?.requestOptions.uri} start ]---------------");

    ///convert request to json
    var requestData = {
      'method': err.response?.requestOptions.method,
      'url': err.response?.requestOptions.uri.toString(),
      'headers': err.response?.headers,
      'body': err.response?.data,
      'statusCode': err.response?.statusCode,
      'error': err,
    };
    _printPrettyJson(requestData, "the content of error is ", "error");
    _logger.i(
        "-----------------[ error of request ${err.response?.requestOptions.uri} end ]---------------");

    handler.next(err);
  }

  void _printPrettyJson(
      Map<String, dynamic> jsonData, String tag, String logType) {
    // const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyJson = jsonData.toString();
    switch (logType.toLowerCase()) {
      case "request":
        _logger.d("$tag : $prettyJson");
        break;
      case "response":
        _logger.f(
          "$tag : $prettyJson",
        );
        break;
      case "error":
        _logger.e(
          "$tag : $prettyJson",
        );
        break;
      default:
        _logger.i("$tag : $prettyJson");
        break;
    }
  }

  /// Convert FormData to Map
  Map<String, dynamic> _formDataToMap(FormData formData) {
    final map = <String, dynamic>{};
    // Add fields to the map
    for (final field in formData.fields) {
      map[field.key] = field.value;
    }

    // Add files to the map
    for (final file in formData.files) {
      map[file.key] = file.value.filename;
    }
    return map;
  }
}
