function guid_remove(guid) {
    if (Identifiers.guids[$ guid]) variable_struct_remove(Identifiers.guids, guid);
}

function guid_generate() {
    var n;
    do {
        n = Game.meta.project.id + ":" + string_hex(Game.meta.extra.guid_current++, 8);
    } until (!Identifiers.guids[$ n]);
    
    return  n;
}

function guid_get(value) {
    return Identifiers.guids[$ value];
}

function guid_set(data, addition, force) {
    if (addition == undefined) addition = data.GUID;
    if (force == undefined) force = false;
    
    // almost all data is automatically created with a GUID, so remove it
    if (Identifiers.guids[$ data.GUID]) {
        variable_struct_remove(Identifiers.guids, addition);
    }
    
    // if there's a collision, you ought to be informed (and explode)
    if (Identifiers.guids[$ addition]) {
        show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false);
    }
    
    Identifiers.guids[$ addition] = data;
    data.GUID = addition;
}