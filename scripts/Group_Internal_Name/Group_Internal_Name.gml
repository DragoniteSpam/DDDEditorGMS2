function internal_name_generate(data, base_name) {
    var target_name = base_name;
    
    var n = 0;
    while (internal_name_get(target_name)) {
        target_name = base_name + "_" + string_hex(n++, 4);
    }
    
    internal_name_set(data, target_name);
}

function internal_name_get(name) {
    if (Identifiers.internal[$ name]) {
        return Identifiers.internal[$ name];
    }
    
    return undefined;
}

function internal_name_remove(name) {
    if (Identifiers.internal[$ name]) {
        variable_struct_remove(Identifiers.internal, name);
        return true;
    }
    
    return false;
}

function internal_name_set(data, new_name = data.internal_name, force = false) {
    if (string_length(data.internal_name) > 0) {
        variable_struct_remove(Identifiers.internal, data.internal_name);
    }
    
    if (Identifiers.internal[$ new_name]) {
        return false;
    }
    
    Identifiers.internal[$ new_name] = data;
    data.internal_name = new_name;
    return true;
}