## 1.7.0

- In this version, several enhancements and optimizations have been made to improve both functionality and code flexibility:

Enhanced Interceptor Customization: Updated the CustomInterceptors class to allow asynchronous (Future) handling in customRequestHandler, customResponseHandler, and customErrorHandler. This change enables support for asynchronous operations within custom handlers, improving versatility and allowing network calls, database access, or other async operations during request and response interception.

Improved Error Handling and Logging: Refined error handling mechanisms for better accuracy and granularity. Enhanced logging now provides clearer, more detailed insights into request/response data, making debugging and monitoring easier.