/// @param name
/// @param data[][]
/// @param outbound-names[]

with (instance_create_depth(0, 0, 0, DataEventNodeCustomPersistent)) {
    name = argument[0];
    var template = argument[1];
    var outbound_names = (argument_count > 2 && is_array(argument[2])) ? argument[2] : [""];
    
    for (var i = 0; i < array_length_1d(template); i++) {
        var data = template[i];
        var len = array_length_1d(data);
        
        var data_name = data[0];
        var data_type = data[1];
        var data_guid = (len > 2) ? data[2] : 0;    // only useful for Data types
        var data_max = (len > 3) ? data[3] : 1;
        var data_required = (len > 4) ? data[4] : false;
        var data_default = (len > 5) ? data[5] : 0;
        var data_attainment = (len > 6) ? data[6] : null;
        var data_output = (len > 7) ? data[7] : null;
        
        /// @gml update lightweight objects
        ds_list_add(types, [data_name, data_type, data_guid, data_max, data_required, data_default, data_attainment, data_output]);
    }
    
    for (var i = 0; i < array_length_1d(outbound_names); i++) {
        ds_list_add(outbound, outbound_names[i]);
    }
    
    return id;
}

// [name, DataType, DataType guid, max = 1, all list elements required = false, default-value = 0,
//    value-attainment = null, output-string = null]