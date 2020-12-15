function graphics_add_generic(filename, prefix, list, name, remove_back) {
    if (name == undefined) name = filename_name(filename);
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    remove_back &= !keyboard_check(vk_control);
    
    var data = instance_create_depth(0, 0, 0, DataImage);
    data.name = name;
    data.picture = sprite_add(filename, 0, remove_back, false, 0, 0);
    data.width = sprite_get_width(data.picture);
    data.height = sprite_get_height(data.picture);
    
    internal_name_generate(data, prefix + internal_name);
    ds_list_add(list, data);
    
    return data;
}

function graphics_remove_overworld(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_overworlds, ds_list_find_index(Stuff.all_graphic_overworlds, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_battler(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_battlers, ds_list_find_index(Stuff.all_graphic_battlers, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_etc(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_etc, ds_list_find_index(Stuff.all_graphic_etc, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_particle(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_particles, ds_list_find_index(Stuff.all_graphic_particles, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_skybox(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_skybox, ds_list_find_index(Stuff.all_graphic_skybox, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function graphics_remove_ui(guid) {
    var data = guid_get(guid);
    ds_list_delete(Stuff.all_graphic_ui, ds_list_find_index(Stuff.all_graphic_ui, data));
    instance_activate_object(data);
    instance_destroy(data);
}