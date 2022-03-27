function event_prefab_render_input_type_name(event, index) {
    switch (event.custom_data[2][0]) {
        case 0: return "Text";
        case 1: return "Text (Scribble safe)";
        case 2: return "Integer";
        case 3: return "Unsigned Integer";
        case 4: return "Floating Point";
    }
    
    return "?";
}

function event_prefab_render_variable_name(event, index) {
    var raw = event.custom_data[0][0];
    
    if (!is_clamped(raw, 0, array_length(Game.vars.variables))) {
        return "n/a";
    }
    
    return Game.vars.variables[raw].name;
}

function event_prefab_render_switch_name(event, index) {
    var raw = event.custom_data[0][0];
    
    if (!is_clamped(raw, 0, array_length(Game.vars.switches))) {
        return "n/a";
    }
    
    return Game.vars.switches[raw].name;
}

function event_prefab_render_self_variable_name(event, index) {
    return chr(ord("A") + event.custom_data[1][0]);
}

function event_prefab_render_mesh_animation_end_action(event, index) {
    return global.animation_end_action_names[event.custom_data[2][0]];
}

function event_prefab_render_map_name(event, index) {
    var map = guid_get(event.custom_data[0][0]);
    return map ? map.name : "<no map>";
}

function event_prefab_render_map_direction_name(event, index) {
    var raw = event.custom_data[4][0];
    
    switch (raw) {
        case 0: return "Down";
        case 1: return "Left";
        case 2: return "Right";
        case 3: return "Up";
    }
}

function event_prefab_render_input_variable_name(event, index) {
    var raw = event.custom_data[1][0];
    
    if (!is_clamped(raw, 0, array_length(Game.vars.variables))) {
        return "n/a";
    }
    
    return Game.vars.variables[raw].name;
}

function event_prefab_render_self_switch_name(event, index) {
    return chr(ord("A") + event.custom_data[1][0]);
}