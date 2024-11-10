
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class CustomInterceptors extends Interceptor {
  final RequestOptions Function(RequestOptions options)? customRequestHandler;
  final Response Function(Response response)? customResponseHandler;
  final DioException Function(DioException error)? customErrorHandler;
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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// add custom request handler
    if (customRequestHandler != null) {
      options = customRequestHandler!(options);
    }

    /// Check if the content type is form-data
    if (options.headers['Content-Type'] == 'multipart/form-data') {
      if(options.data is FormData){
        FormData formData = options.data as FormData;
        options.data = _formDataToMap(formData);
      }
    }

    ///convert request to json
    var requestData = {
      'method': options.method,
      'url': options.uri.toString(),
      'headers': options.headers,
      'body': options.data
    };
    _logger
        .i("-----------------[ request ${options.uri} start ]---------------");
    _printPrettyJson(requestData, "the content of request is", "request");
    _logger.i("-----------------[ request ${options.uri} end ]---------------");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    /// add custom response handler
    if (customResponseHandler != null) {
      response = customResponseHandler!(response);
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    /// add custom error handler
    if (customErrorHandler != null) {
     err= customErrorHandler!(err);
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
