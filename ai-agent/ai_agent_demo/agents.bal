import ballerinax/ai.agent;

final agent:OpenAiModel _MathTutorModel = check new (apiKey, "gpt-4o-2024-08-06");
final agent:Agent _MathTutorAgent = check new (
    systemPrompt = {role: "Math Tutor", instructions: string `You are a school tutor assistant. Provide answers to students' questions so they can compare their answers. Use the tools when there is query related to math\"`}, model = _MathTutorModel, tools = [getmulti]
);

@agent:Tool
@display {label: "", iconPath: ""}
isolated function getmulti(decimal a, decimal b) returns decimal {
    decimal result = multi(a, b);
    return result;
}
