function event_prefab_render_switch_name(event, index) {
    var raw = event.custom_data[0][0];
    
    if (!is_clamped(raw, 0, array_length(Game.vars.switches))) {
        return "n/a";
    }
    
    return Game.vars.switches[raw].name;
}