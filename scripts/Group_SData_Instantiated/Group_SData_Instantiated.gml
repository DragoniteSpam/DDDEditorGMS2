function SDataInstance(name) : SData(name) constructor {
    parent = NULL;
    values = [];
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        var class = guid_get(self.parent);
        for (var i = 0; i < array_length(class.properties); i++) {
            var type = Stuff.data_type_meta[class.properties[i].type].buffer_type;
            buffer_write(buffer, buffer_u16, array_length(self.values[i]));
            for (var j = 0; j < array_length(self.values[i]); j++) {
                buffer_write(buffer, type, self.values[i][j]);
            }
        }
    };
}