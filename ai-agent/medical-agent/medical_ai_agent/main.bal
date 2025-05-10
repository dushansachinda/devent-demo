import ballerina/http;
import ballerinax/ai;
import ballerina/log;

service /healthcare on new http:Listener(8290) {
    resource function get doctors/[string doctorType]() returns Doctor[]|error {
        Doctor[] doctors = [];

        // Call PineValley backend
        PineValleyRequest payload = {doctorType: doctorType};
        log:printInfo("PineValley request:", res = payload.toString());
        PineValleyResponse pineValleyResponse = check pineValleyEp->post("/doctors", message = payload);
        log:printInfo("PineValley response:", res = pineValleyResponse.toString());
        doctors.push(...pineValleyResponse.doctors);

        // Call GrandOak backend
        GrandOakResponse grandOakResponse = check grandOakEp->get("/doctors/" + doctorType);
        log:printInfo("GrandOak response:", res = grandOakResponse.toString());
        doctors.push(...grandOakResponse.doctors);

        return doctors;
    }
}

service /DoctorBookingAgent on new ai:Listener(9100) {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check _DoctorBookingAgent->run(query = request.message);
        return {message: stringResult};
    }
}