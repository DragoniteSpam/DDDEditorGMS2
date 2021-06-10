function internal_name_generate(data, base_name) {
    var target_name = base_name;
    
    var n = 0;
    while (internal_name_get(target_name)) {
        target_name = base_name + "_" + string_hex(n++, 4);
    }
    
    internal_name_set(data, target_name);
}

function internal_name_get(name) {
    if (ds_map_exists(Identifiers.internal, name)) {
        return Identifiers.internal[? name];
    }
    
    return noone;
}

function internal_name_remove(name) {
    if (ds_map_exists(Identifiers.internal, name)) {
        ds_map_delete(Identifiers.internal, name);
        return true;
    }
    
    return false;
}

function internal_name_set(data, new_name, force) {
    if (new_name == undefined) new_name = data.internal_name;
    if (force == undefined) force = false;
    
    if (string_length(data.internal_name) > 0) {
        ds_map_delete(Identifiers.internal, data.internal_name);
    }
    
    if (ds_map_exists(Identifiers.internal, new_name)) {
        return false;
    }
    
    // unset the data's existing internal name
    if (ds_map_exists(Identifiers.internal, data.internal_name)) {
        ds_map_delete(Identifiers.internal, data.internal_name);
    }
    
    ds_map_add(Identifiers.internal, new_name, data);
    data.internal_name = new_name;
    return true;
}