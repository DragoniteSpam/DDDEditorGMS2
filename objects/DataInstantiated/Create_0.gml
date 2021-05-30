event_inherited();

base_guid = NULL;
// this is a list of lists
values = ds_list_create();

CreateJSONInst = function() {
    var json = self.CreateJSONBase();
    var parent = guid_get(base_guid);
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