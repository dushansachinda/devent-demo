type Pizza record {|
    string id;
    string name;
    decimal price;
    string[] toppings;
|};

type CustomerDetails record {|
    string name;
    string phoneNumber;
    string email;
    string address;
|};

type Order record {|
    string orderId;
    CustomerDetails customerDetails;
    string[] pizzaIds;
    string status;
    decimal totalAmount;
|};

type OrderRequest record {|
    CustomerDetails customerDetails;
    string[] pizzaIds;
|};