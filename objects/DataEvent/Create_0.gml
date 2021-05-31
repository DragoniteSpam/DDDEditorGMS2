event_inherited();

nodes = ds_list_create();
name_map = { };
event_create_node(id, EventNodeTypes.ENTRYPOINT, 64, 64);

CreateJSONEvent = function() {
    var json = self.CreateJSONBase();
    json.name_map = json_stringify(self.name_map);
    json.nodes = array_create(ds_list_size(self.nodes));
    for (var i = 0, n = ds_list_size(self.nodes); i < n; i++) {
        json.nodes[i] = self.nodes[| i].CreateJSON();
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEvent();
};