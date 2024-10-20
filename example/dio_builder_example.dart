// Example usage of DioBuilderBase
import 'package:dio/dio.dart';
import 'package:dio_builder/dio_builder.dart';

void main() async {
  final dioBuilder = DioBuilderBase(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    responseType: ResponseType.json,
    contentType: Headers.jsonContentType,
    customRequestHandler: (options) {
      print('Request: ${options.method} ${options.path}');
      return options;
    },
    customResponseHandler: (response) {
      print('Response: ${response.statusCode} ${response.data}');
      return response;
    },
    customErrorHandler: (error) {
      print('Error: ${error.message}');
    },
  );

  // Example GET request
  final getResult = await dioBuilder.get('/posts/1');
  getResult.fold(
    (error) => print('GET Error: $error'),
    (response) => print('GET Response: ${response.data}'),
  );

  // Example POST request
  final postResult = await dioBuilder.post('/posts', body: {'title': 'foo', 'body': 'bar', 'userId': 1});
  postResult.fold(
    (error) => print('POST Error: $error'),
    (response) => print('POST Response: ${response.data}'),
  );

  // Example PUT request
  final putResult = await dioBuilder.put('/posts/1', body: {'id': 1, 'title': 'updated title', 'body': 'updated body', 'userId': 1});
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