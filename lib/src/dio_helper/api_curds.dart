abstract class IApiCurds<Type>{
  Future<Type> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic options,
      });
  Future<Type> post(
      String path, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? body,
        dynamic options,
      });
  Future<Type> delete(
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic options,
      });
  Future<Type> put(
      String path, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? body,
        dynamic options,
      });
}
