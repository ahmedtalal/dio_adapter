## 1.7.0

- In this version, several enhancements and optimizations have been made to improve both functionality and code flexibility:

Enhanced Interceptor Customization: Updated the CustomInterceptors class to allow asynchronous (Future) handling in customRequestHandler, customResponseHandler, and customErrorHandler. This change enables support for asynchronous operations within custom handlers, improving versatility and allowing network calls, database access, or other async operations during request and response interception.

Improved Error Handling and Logging: Refined error handling mechanisms for better accuracy and granularity. Enhanced logging now provides clearer, more detailed insights into request/response data, making debugging and monitoring easier.

## 1.8.0

- In this version, Added a ContentTypeEnum to represent commonly used content types (application/json, application/xml, text/plain, application/x-www-form-urlencoded, multipart/form-data, application/octet-stream). Each type now includes a string representation for easy integration into request headers.
  Extended the ContentTypeEnum with a new value getter, enabling simplified and error-free assignment of content types in requests. This enhancement minimizes repetitive string definitions and ensures greater consistency in API calls.

## 1.9.0

- In this version, Added extra parameter 'handler' to customRequestHandler, customResponseHandler, and customErrorHandler. This parameter allows for asynchronous handling of request and response data during custom handlers.

## 2.0.0

- In this version, handle some warning in the pacakge and enhancement in prettyjson method to print response in a better format .

## 2.0.1

- In this version, handle some warning in the pacakge


## 2.1.1

- In this version,add the logic of ssl pinning to the package