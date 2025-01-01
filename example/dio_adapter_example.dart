// Example usage of DioBuilderBase
import 'package:dio_adapter/dio_adapter.dart';

void main() async {
  final dioBuilder = DioAdapterBase(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: Duration(seconds: 10000),
    receiveTimeout: Duration(seconds: 10000),
    contentTypeEnum: ContentTypeEnum.applicationJson,
    responseTypeEnum: ResponseTypeEnum.json,
    sslCertificateSHa256: null,
    customRequestHandler: (options, handler) async {
      // Do something before request is sent.
      // If you want to resolve the request with custom data,
      // you can resolve a `Response` using `handler.resolve(response)` like this
      //// Check if the request matches a condition (e.g., specific URL or headers)
      //       if (options.path.contains("/mock-endpoint")) {
      //         // Create a mock Response
      //         final mockResponse = Response(
      //           requestOptions: options,
      //           data: {"message": "This is a mock response"},
      //           statusCode: 200,
      //           statusMessage: "OK",
      //         );
      //         // Resolve the request with the mock response
      //         return handler.resolve(mockResponse);
      //       }
      // If you want to reject the request with a error message,
      // you can reject with a `DioException` using `handler.reject(dioError)` like this
      //  final token = options.headers["Authorization"];
      //       if (token == null || token.isEmpty) {
      //         return handler.reject(
      //           DioException(
      //             requestOptions: options,
      //             type: DioExceptionType.badResponse,
      //             error: "Unauthorized: Missing or invalid token",
      //           ),
      //         );
      //       }
      return options;
    },
    customResponseHandler: (response, handler) async {
      // Do something with response data.
      // If you want to reject the request with a error message,
      // you can reject a `DioException` object using `handler.reject(dioError)`.
      return response;
    },
    customErrorHandler: (error, handler) async {
      // Do something with response error.
      // If you want to resolve the request with some custom data,
      // you can resolve a `Response` object using `handler.resolve(response)`.
      return error;
    },
  );

  // Example GET request
  final getResult = await dioBuilder.get('/posts/1');
  getResult.fold(
    (error) => print('GET Error: $error'),
    (response) => print('GET Response: ${response.data}'),
  );

  //Example POST request
  final postResult = await dioBuilder
      .post('/posts', body: {'title': 'foo', 'body': 'bar', 'userId': 1});
  postResult.fold(
    (error) => print('POST Error: $error'),
    (response) => print('POST Response: ${response.data}'),
  );

  // Example PUT request
  final putResult = await dioBuilder.put('/posts/1', body: {
    'id': 1,
    'title': 'updated title',
    'body': 'updated body',
    'userId': 1
  });
  putResult.fold(
    (error) => print('PUT Error: $error'),
    (response) => print('PUT Response: ${response.data}'),
  );

  // Example DELETE request
  final deleteResult = await dioBuilder.delete('/posts/1');
  deleteResult.fold(
    (error) => print('DELETE Error: $error'),
    (response) => print('DELETE Response: ${response.statusCode}'),
  );
}
