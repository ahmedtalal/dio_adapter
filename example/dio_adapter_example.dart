// Example usage of DioBuilderBase
import 'package:dio_adapter/dio_adapter.dart';

void main() async {
  final dioBuilder = DioAdapterBase(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: Duration(seconds: 10000),
    receiveTimeout: Duration(seconds: 10000),
    contentType: "application/json",
    responseTypeEnum: ResponseTypeEnum.json,
    customRequestHandler: (options) {
      /// todo:you logic here
      return options;
    },
    customResponseHandler: (response) {
      /// todo:you logic here
      return response;
    },
    customErrorHandler: (error) {
      /// todo:you logic here
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