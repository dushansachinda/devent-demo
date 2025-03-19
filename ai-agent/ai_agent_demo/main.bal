import ballerina/http;
import ballerinax/ai.agent;

listener agent:Listener MathTutorListener = new (listenOn = check http:getDefaultListener());

service /MathTutor on MathTutorListener {
    resource function post chat(@http:Payload agent:ChatReqMessage request) returns agent:ChatRespMessage|error {

        string stringResult = check _MathTutorAgent->run(request.message);
        return {message: stringResult};
    }
}
