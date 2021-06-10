function guid_remove(guid) {
    if (Identifiers.guid[$ guid]) variable_struct_remove(Identifiers.guid, guid);
}

function guid_generate() {
    var n;
    do {
        n = Game.meta.project.id + ":" + string_hex(Game.temp.current++, 8);
    } until (!Identifiers.guid[$ n]);
    
    return  n;
}

function guid_get(value) {
    return Identifiers.guid[$ value];
}

function guid_set(data, addition, force) {
    if (addition == undefined) addition = data.GUID;
    if (force == undefined) force = false;
    
    // almost all data is automatically created with a GUID, so remove it
    if (Identifiers.guid[$ data.GUID]) {
        variable_struct_remove(Identifiers.guid, addition);
    }
    
    // if there's a collision, you ought to be informed (and explode)
    if (Identifiers.guid[$ addition]) {
        show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false);
    }
    
    Identifiers.guid[$ addition] = data;
    data.GUID = addition;
}