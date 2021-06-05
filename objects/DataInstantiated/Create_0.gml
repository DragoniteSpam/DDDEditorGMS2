event_inherited();

base_guid = NULL;
// this is a list of lists
values = ds_list_create();

LoadJSONInst = function(struct) {
    self.LoadJSONBase(struct);
    for (var i = 0, n = array_length(struct.values); i < n; i++) {
        var sub = ds_list_create();
        ds_list_add(self.values, sub);
        for (var j = 0, n2 = array_length(struct.values[i]); j < n2; j++) {
            ds_list_add(sub, struct.values[i][j]);
        }
    }
};

LoadJSON = function(struct) {
    self.LoadJSONInst(struct);
};

CreateJSONInst = function() {
    var json = self.CreateJSONBase();
    var n = ds_list_size(self.values);
    json.values = array_create(n);
    for (var i = 0; i < n; i++) {
        var value_count = ds_list_size(self.values[| i]);
        json.values[i] = array_create(value_count);
        for (var j = 0; j < value_count; j++) {
            json.values[i][j] = self.values[| i][| j];
        }
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONInst();
};