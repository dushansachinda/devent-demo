import ballerina/http;

final http:Client pineValleyEp = check new (url = pineValleyUrl);
final http:Client grandOakEp = check new (url = grandOakUrl);
