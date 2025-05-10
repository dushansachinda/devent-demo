import ballerina/http;
import ballerinax/ai;
import ballerina/io;

final http:Client hospitalClient = check new ("http://localhost:8290/healthcare");

final ai:OpenAiProvider _DoctorBookingModel = check new (apiKey = apiKey, modelType = ai:GPT_4O_2024_08_06);
final ai:Agent _DoctorBookingAgent = check new (
    systemPrompt = {role: "Doctor Booking Assistant", instructions: string `You are a doctor booking assistant. Provide answers to patients' questions related to doctors availability. Use the tools when there is query related to doctor availability`}, 
    model = _DoctorBookingModel, 
    tools = [getDoctors]
);

@ai:AgentTool
@display {
    label: "",
    iconPath: ""
}
isolated function getDoctors(string doctorType) returns Doctor[]|error {
    io:println(doctorType);
    Doctor[]|http:ClientError doctors = hospitalClient->get("/doctors/" + doctorType);
    if doctors is http:ClientError {
        io:println(doctors);
    }
    io:println(doctors);
    return doctors;
}