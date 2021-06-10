function guid_remove(guid) {
    if (Game.temp.guids[$ guid]) variable_struct_remove(Game.temp.guids, guid);
}

function guid_generate() {
    var n;
    do {
        n = Game.meta.project.id + ":" + string_hex(Stuff.guid_current++, 8);
    } until (!Game.temp.guids[$ n]);
    
    return  n;
}

function guid_get(value) {
    return Game.temp.guids[$ value];
}

function guid_set(data, addition, force) {
    if (addition == undefined) addition = data.GUID;
    if (force == undefined) force = false;
    
    // almost all data is automatically created with a GUID, so remove it
    if (Game.temp.guids[$ data.GUID]) {
        variable_struct_remove(Game.temp.guids, addition);
    }
    
    // if there's a collision, you ought to be informed (and explode)
    if (Game.temp.guids[$ addition]) {
        show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false);
    }
    
    Game.temp.guids[$ addition] = data;
    data.GUID = addition;
}