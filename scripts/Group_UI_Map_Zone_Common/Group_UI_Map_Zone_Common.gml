function uivc_input_map_zone_name(input) {
    Stuff.map.selected_zone.name = input.value;
    input.root.text = "Zone Settings: " + input.value;
    input.root.root.text = "Data: " + input.value;
}

function uivc_input_map_zone_priority(input) {
    Stuff.map.selected_zone.zone_priority = real(input.value);
}

function uivc_input_map_zone_x1(input) {
    Stuff.map.selected_zone.x1 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function uivc_input_map_zone_x2(input) {
    Stuff.map.selected_zone.x2 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function uivc_input_map_zone_y1(input) {
    Stuff.map.selected_zone.y1 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function uivc_input_map_zone_y2(input) {
    Stuff.map.selected_zone.y2 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function uivc_input_map_zone_z1(input) {
    Stuff.map.selected_zone.z1 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function uivc_input_map_zone_z2(input) {
    Stuff.map.selected_zone.z2 = real(input.value);
    map_zone_collision(Stuff.map.selected_zone);
}

function ui_list_color_effect_components(list, index) {
    var effect = refid_get(list.entries[| index]);
    if (!effect) return c_black;
    
    for (var i = 0; i < ds_list_size(list.entries); i++) {
        if (i == index) continue;
        if (list.entries[| i] == list.entries[| index]) return c_orange;
    }
    
    return effect.com_light ? effect.com_light.label_colour : c_red;
}