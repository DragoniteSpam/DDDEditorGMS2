event_inherited();

// filename

flags = [[]];

CreateJSONTS = function() {
    var json = self.CreateJSONBase();
    json.flags = flags;
    return json;
};

CreateJSON = function() {
    return self.CreateJSONTS();
};