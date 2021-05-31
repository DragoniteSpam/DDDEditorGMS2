function DataConstant(name) : SData(name) constructor {
    self.type = DataTypes.INT;
    self.type_guid = NULL;
    self.value = 0;
    
    static CreateJSONConst = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
        json.type_guid = self.type_guid;
        json.value = self.value; 
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONConst();
    };
}