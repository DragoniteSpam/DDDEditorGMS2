function guid_remove(guid) {
    if (ds_map_exists(Stuff.all_guids, guid)) {
        ds_map_delete(Stuff.all_guids, guid);
        return true;
    }
    
    return false;
}

function guid_generate() {
    do {
        var n = Stuff.game_asset_id + ":" + string_hex(Stuff.guid_current++, 8);
    } until (!ds_map_exists(Stuff.all_guids, n));
    
    return  n;
}

function guid_get(value) {
    return Stuff.all_guids[? value];
}

function guid_set(data, addition, force) {
    if (addition == undefined) addition = data.GUID;
    if (force == undefined) force = false;
    
    // almost all data is automatically created with a GUID, so remove it
    if (ds_map_exists(Stuff.all_guids, addition)) {
        ds_map_delete(Stuff.all_guids, addition);
    }
    
    // if there's a collision, you ought to be informed (and explode)
    if (ds_map_exists(Stuff.all_guids, addition)) {
        show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false)
    }
    
    Stuff.all_guids[? addition] = data;
    data.GUID = addition;
}