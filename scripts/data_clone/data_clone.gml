// in case you need to back up and restore the DataData somewhere
// the cloned instances have GUIDs, but they're not included in the
// GUID map

var clone = ds_list_create();

for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
    var data = Stuff.all_data[| i];
    
    with (instance_create_depth(0, 0, 0, DataData)) {
        guid_remove(GUID);
        ds_list_pop(Stuff.all_data)
        
        name = data.name;
        summary = data.summary;
        is_enum = data.is_enum;
        
        GUID = data.GUID;
        
        if (!data.is_enum) {
            // pass-by-reference; we need to know these later . . . probably
            instances = data.instances;
            is_cached = true;
        }
        
        // this is NOT pass-by-reference
        for (var j = 0; j < ds_list_size(data.properties); j++) {
            var property = data.properties[| j];
            
            with (instance_create_depth(0, 0, 0, DataProperty)) {
                guid_remove(GUID);
                
                name = property.name;
                summary = property.summary;
                type = property.type;
                
                GUID = property.GUID;
                
                range_min = property.range_min;
                range_max = property.range_max;
                number_scale = property.number_scale;
                char_limit = property.char_limit;
                type_guid = property.type_guid;
                
                ds_list_add(other.properties, id);
            }
        }
        
        ds_list_add(clone, id);
    }
}

return clone;