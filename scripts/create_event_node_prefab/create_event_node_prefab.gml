/// @param name
/// @param data[][]

with (instantiate(DataEventNodeCustom)) {
    name = argument0;
    deleteable = false;
    
    for (var i = 0; i < array_length_1d(argument1); i++) {
        var data = argument1[i];
        switch (array_length_1d(data)) {
            case 7: ds_list_add(types, data); break;
            case 6: ds_list_add(types, [data[0], data[1], data[2], data[3], data[4], data[5], null]); break;
            case 5: ds_list_add(types, [data[0], data[1], data[2], data[3], data[4], 0, null]); break;
            case 4: ds_list_add(types, [data[0], data[1], data[2], data[3], false, 0, null]); break;
            case 3: ds_list_add(types, [data[0], data[1], data[2], 1, false, 0, null]); break;
        }
    }
    
    return id;
}

// [name, DataType, DataType guid, max = 1, all list elements required = false, default-value = 0, value-attainment = null]