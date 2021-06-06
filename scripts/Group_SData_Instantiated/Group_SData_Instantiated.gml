function SDataInstance(name) : SData(name) constructor {
    base_guid = NULL;
    values = [];
    
    LoadJSONInst = function(struct) {
        self.LoadJSONBase(struct);
        self.values = struct.values;
        self.base_guid = struct.base_guid;
    };
    
    LoadJSON = function(struct) {
        self.LoadJSONInst(struct);
    };
    
    CreateJSONInst = function() {
        var json = self.CreateJSONBase();
        json.base_guid = self.base_guid;
        json.values = self.values;
        return json;
    };
    
    CreateJSON = function() {
        return self.CreateJSONInst();
    };
}