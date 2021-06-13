function DataEvent(source) : SData(source) {
    self.nodes = ds_list_create();
    self.name_map = { };
    event_create_node(self, EventNodeTypes.ENTRYPOINT, 64, 64);
    
    static CreateJSONEvent = function() {
        var json = self.CreateJSONBase();
        json.name_map = json_stringify(self.name_map);
        json.nodes = array_create(ds_list_size(self.nodes));
        for (var i = 0, n = ds_list_size(self.nodes); i < n; i++) {
            json.nodes[i] = self.nodes[| i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONEvent();
    };
    
    static Destroy = function() {
        ds_list_destroy_instances(self.nodes);
    }
}