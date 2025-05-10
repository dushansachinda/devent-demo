import ballerina/http;

configurable string pineValleyUrl = "http://localhost:8080/pineValley";
configurable string grandOakUrl = "http://localhost:9090/grandOaks";

final http:Client pineValleyEp = check new (url = pineValleyUrl);
final http:Client grandOakEp = check new (url = grandOakUrl);
