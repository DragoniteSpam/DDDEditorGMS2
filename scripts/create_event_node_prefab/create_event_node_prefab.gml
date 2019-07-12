/// @param name
/// @param guid
/// @param data[][]

with (instantiate(DataEventNodeCustom)) {
    name = argument0;
    guid_set(id, argument1);
    deleteable = false;
    
    for (var i = 0; i < array_length_1d(argument2); i++) {
        var data = argument2[i];
        switch (array_length_1d(data)) {
            case 5:
                ds_list_add(types, data);
                break;
            case 4:
                ds_list_add(types, [data[0], data[1], data[2], data[3], false]);
                break;
            default:
                ds_list_add(types, [data[0], data[1], data[2], 1, false]);
                break;
        }
    }
    
    return id;
}

// [name, DataType, DataType guid, max = 1, all list elements required = false]