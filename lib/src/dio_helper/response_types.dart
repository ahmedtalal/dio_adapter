enum ResponseTypeEnum {
  json,
  bytes,
  stream,
  plain,
}

enum ContentTypeEnum {
  /// equal application/Json
  applicationJson,

  /// equal application/xml
  applicationXml,

  /// equal text/plain
  textPlain,

  /// equal application/x-www-form-urlencoded
  applicationXWwwFormUrlencoded,

  /// equal multipart/form-data
  multipartFormData,

  /// equal application/octet-stream
  applicationOctetStream,
}
