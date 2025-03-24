import ballerina/http;
import ballerinax/ai.agent;

// Sample pizza data with more varieties
final readonly & Pizza[] pizzas = [
    {
        id: "P001",
        name: "Margherita",
        price: 12.99,
        toppings: ["Tomato Sauce", "Fresh Mozzarella", "Fresh Basil", "Olive Oil"]
    },
    {
        id: "P002",
        name: "Pepperoni",
        price: 14.99,
        toppings: ["Tomato Sauce", "Mozzarella", "Pepperoni", "Oregano"]
    },
    {
        id: "P003",
        name: "Hawaiian",
        price: 15.99,
        toppings: ["Tomato Sauce", "Mozzarella", "Ham", "Pineapple"]
    },
    {
        id: "P004",
        name: "BBQ Chicken",
        price: 16.99,
        toppings: ["BBQ Sauce", "Mozzarella", "Grilled Chicken", "Red Onions", "Cilantro"]
    },
    {
        id: "P005",
        name: "Vegetarian Supreme",
        price: 15.99,
        toppings: ["Tomato Sauce", "Mozzarella", "Bell Peppers", "Mushrooms", "Red Onions", "Black Olives", "Baby Spinach"]
    },
    {
        id: "P006",
        name: "Meat Lovers",
        price: 17.99,
        toppings: ["Tomato Sauce", "Mozzarella", "Pepperoni", "Italian Sausage", "Bacon", "Ground Beef"]
    },
    {
        id: "P007",
        name: "Buffalo Chicken",
        price: 16.99,
        toppings: ["Buffalo Sauce", "Mozzarella", "Grilled Chicken", "Red Onions", "Ranch Drizzle"]
    },
    {
        id: "P008",
        name: "Four Cheese",
        price: 15.99,
        toppings: ["Tomato Sauce", "Mozzarella", "Parmesan", "Gorgonzola", "Ricotta"]
    }
];

// In-memory order storage
map<Order> orders = {};

service /v1 on new http:Listener(8080) {
    resource function get pizzas() returns Pizza[] {
        return pizzas;
    }

    resource function post orders(@http:Payload OrderRequest orderRequest) returns Order|error {
        string orderId = "ORD" + orders.length().toString();

        decimal totalAmount = 0;
        foreach string pizzaId in orderRequest.pizzaIds {
            boolean pizzaFound = false;
            foreach Pizza pizza in pizzas {
                if pizza.id == pizzaId {
                    totalAmount += pizza.price;
                    pizzaFound = true;
                    break;
                }
            }
            if !pizzaFound {
                return error("Invalid pizza ID: " + pizzaId);
            }
        }

        Order newOrder = {
            orderId: orderId,
            customerDetails: orderRequest.customerDetails,
            pizzaIds: orderRequest.pizzaIds,
            status: "PENDING",
            totalAmount: totalAmount
        };

        orders[orderId] = newOrder;
        return newOrder;
    }

    resource function get orders/[string orderId]() returns Order|error {
        if !orders.hasKey(orderId) {
            return error("Order not found");
        }
        return orders.get(orderId);
    }

    resource function patch orders/[string orderId](@http:Payload OrderRequest orderRequest) returns Order|error {
        if !orders.hasKey(orderId) {
            return error("Order not found");
        }

        Order existingOrder = orders.get(orderId);
        decimal totalAmount = 0;
        foreach string pizzaId in orderRequest.pizzaIds {
            boolean pizzaFound = false;
            foreach Pizza pizza in pizzas {
                if pizza.id == pizzaId {
                    totalAmount += pizza.price;
                    pizzaFound = true;
                    break;
                }
            }
            if !pizzaFound {
                return error("Invalid pizza ID: " + pizzaId);
            }
        }

        Order updatedOrder = {
            orderId: orderId,
            customerDetails: orderRequest.customerDetails,
            pizzaIds: orderRequest.pizzaIds,
            status: existingOrder.status,
            totalAmount: totalAmount
        };

        orders[orderId] = updatedOrder;
        return updatedOrder;
    }
}

//listener agent:Listener pizzaorderagentListener = new (listenOn = check http:getDefaultListener());
//listener agent:Listener PizzaAiAgentListener = new (listenOn = check http:getDefaultListener());
listener agent:Listener PizzaAiAgentListener = new (listenOn = check http:getDefaultListener());

service /PizzaAiAgent on PizzaAiAgentListener {
    resource function post chat(@http:Payload agent:ChatReqMessage request) returns agent:ChatRespMessage|error {
        string stringResult = check _pizzaAiAgentagentAgent->run(request.message);
        return {message: stringResult};
    }
}
