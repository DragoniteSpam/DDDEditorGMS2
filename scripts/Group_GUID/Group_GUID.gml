function guid_remove(guid) {
    if (Stuff.all_guids[$ guid]) variable_struct_remove(Stuff.all_guids, guid);
}

function guid_generate() {
    var n;
    do {
        n = Stuff.game_asset_id + ":" + string_hex(Stuff.guid_current++, 8);
    } until (!Stuff.all_guids[$ n]);
    
    return  n;
}

function guid_get(value) {
    return Stuff.all_guids[$ value];
}

function guid_set(data, addition, force) {
    if (addition == undefined) addition = data.GUID;
    if (force == undefined) force = false;
    
    // almost all data is automatically created with a GUID, so remove it
    if (Stuff.all_guids[$ data.GUID]) {
        variable_struct_remove(Stuff.all_guids, addition);
    }
    
    // if there's a collision, you ought to be informed (and explode)
    if (Stuff.all_guids[$ addition]) {
        show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false);
    }
    
    Stuff.all_guids[$ addition] = data;
    data.GUID = addition;
}