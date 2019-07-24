/// @param name
/// @param data[][]

with (instantiate(DataEventNodeCustom)) {
    name = argument0;
    deleteable = false;
    
    for (var i = 0; i < array_length_1d(argument1); i++) {
        var data = argument1[i];
        var len = array_length_1d(data);
        
        var data_name = data[0];
        var data_type = data[1];
        var data_guid = (len > 2) ? data[2] : 0;
        var data_max = (len > 3) ? data[3] : 1;
        var data_required = (len > 4) ? data[4] : false;
        var data_default = (len > 5) ? data[5] : 0;
        var data_attainment = (len > 6) ? data[6] : null;
        var data_output = (len > 7) ? data[7] : null;
        
        ds_list_add(types, [data_name, data_type, data_guid, data_max, data_required, data_default, data_attainment, data_output]);
    }
    
    return id;
}

// [name, DataType, DataType guid, max = 1, all list elements required = false, default-value = 0,
//    value-attainment = null, output-string = null]