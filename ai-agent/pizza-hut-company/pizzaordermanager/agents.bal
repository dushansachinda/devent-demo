import ballerinax/ai.agent;

final agent:OpenAiModel _pizzaAiAgentModel = check new (apikey, "gpt-4o-2024-08-06");
final agent:Agent _pizzaAiAgentagentAgent = check new (
    systemPrompt = {role: "Order Management Assistant", instructions: string `You are a pizza order management assistant, designed to guide cashiers through each step of the order management process, asking relevant questions to ensure orders are handled accurately and efficiently.`}, model = _pizzaAiAgentModel, tools = [getPizzas, createOrder, getOrders,getOrder,updateOrder]
);

