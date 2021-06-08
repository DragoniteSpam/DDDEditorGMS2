function SDataInstance(name) : SData(name) constructor {
    parent = NULL;
    values = [];
    
    LoadJSONInst = function(struct) {
        self.LoadJSONBase(struct);
        self.values = struct.values;
        self.parent = struct.parent;
    };
    
    LoadJSON = function(struct) {
        self.LoadJSONInst(struct);
    };
    
    CreateJSONInst = function() {
        var json = self.CreateJSONBase();
        json.parent = self.parent;
        json.values = self.values;
        return json;
    };
    
    CreateJSON = function() {
        return self.CreateJSONInst();
    };
}