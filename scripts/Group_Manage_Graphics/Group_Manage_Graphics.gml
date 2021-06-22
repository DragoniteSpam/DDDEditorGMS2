function graphics_add_generic(filename, prefix, list, name, remove_back) {
    if (name == undefined) name = filename_name(filename);
    if (remove_back == undefined) remove_back = true;
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = new DataImage(name);
    data.picture = sprite_add(filename, 0, false, false, 0, 0);
    data.width = sprite_get_width(data.picture);
    data.height = sprite_get_height(data.picture);
    
    internal_name_generate(data, prefix + internal_name);
    array_push(list, data);
    
    return data;
}

function graphics_remove_overworld(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.overworlds, array_search(Game.graphics.overworlds, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_battler(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.battlers, array_search(Game.graphics.battlers, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_etc(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.etc, array_search(Game.graphics.etc, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_particle(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.particles, array_search(Game.graphics.particles, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_skybox(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.skybox, array_search(Game.graphics.skybox, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_ui(guid) {
    var data = guid_get(guid);
    array_delete(Game.graphics.ui, array_search(Game.graphics.ui, data), 1);
    instance_activate_object(data);
    instance_destroy(data);
}