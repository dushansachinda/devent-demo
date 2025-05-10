type Doctor record {
    string name;
    string time;
    string hospital;
};

// GrandOak specific types
type GrandOakResponse record {
    Doctor[] doctors;
};

// PineValley specific types
type PineValleyResponse record {
    Doctor[] doctors;
};

type PineValleyRequest record {
    string doctorType;
};