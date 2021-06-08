function graphics_add_generic(filename, prefix, list, name, remove_back) {
    if (name == undefined) name = filename_name(filename);
    if (remove_back == undefined) remove_back = true;
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = new DataImage(name);
    data.picture = sprite_add(filename, 0, false, false, 0, 0);
    data.width = sprite_get_width(data.picture);
    data.height = sprite_get_height(data.picture);
    
    internal_name_generate(data, prefix + internal_name);
    ds_list_add(list, data);
    
    return data;
}

function graphics_remove_overworld(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.overworlds, ds_list_find_index(Game.graphics.overworlds, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_battler(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.battlers, ds_list_find_index(Game.graphics.battlers, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_etc(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.etc, ds_list_find_index(Game.graphics.etc, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_particle(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.particles, ds_list_find_index(Game.graphics.particles, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_skybox(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.skybox, ds_list_find_index(Game.graphics.skybox, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_ui(guid) {
    var data = guid_get(guid);
    ds_list_delete(Game.graphics.ui, ds_list_find_index(Game.graphics.ui, data));
    instance_activate_object(data);
    instance_destroy(data);
}