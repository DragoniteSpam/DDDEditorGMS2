function dialog_create_map_default_lights(root) {
    var map = root.root.map;
    var map_contents = map.contents;
    
    var dw = 640;
    var dh = 400;
    
    var dg = dialog_create(dw, dh, "Map Default Lights", undefined, undefined, root);
    dg.map = map;
    
    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / columns + spacing;
    var col2_x = dw * 1 / columns + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = 64;
    
    var el_light_list = create_list(col1_x, yy, "Active Lights", "<no active lights>", ew, eh, 10, function(list) {
        var all_list = list.root.el_available_lights;
        var active_selection = ui_list_selection(list);
        var all_selection = ui_list_selection(all_list);
        if (active_selection + 1) {
            ui_list_deselect(all_list);
            ui_list_select(all_list, ds_list_find_index(all_list.entries, list.entries[active_selection]), true);
        }
    }, false, dg, map.lights);
    el_light_list.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. Effects with no light component (i.e. the light component has been removed) will be shown in red. Duplicate entries will be shown in orange. I recommend giving, at the very least, all of your Light entities unique names.";
    el_light_list.render_colors = ui_list_color_effect_components;
    el_light_list.entries_are = ListEntries.REFIDS;
    dg.el_light_list = el_light_list;
    
    yy += el_light_list.GetHeight() + spacing;
    
    yy = yy_base;
    
    var el_available_lights = create_list(col2_x, yy, "Available Lights:", "<no available lights>", ew, eh, 10, function(list) {
        var active_list = list.root.el_light_list;
        var selection = ui_list_selection(list);
        var active_selection = ui_list_selection(active_list);
        if (active_selection + 1) {
            if (selection + 1) {
                active_list.entries[active_selection] = list.entries[| selection];
            } else {
                active_list.entries[active_selection] = NULL;
            }
        }
    }, false, dg);
    el_available_lights.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index. One light will be reserved for the player at all times.";
    el_available_lights.entries_are = ListEntries.REFIDS;
    for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
        var entity = map_contents.all_entities[| i];
        if (entity.etype == ETypes.ENTITY_EFFECT && entity.com_light) {
            create_list_entries(el_available_lights, [entity.REFID, entity.com_light.label_colour]);
        }
    }
    dg.el_available_lights = el_available_lights;
    
    yy += el_available_lights.GetHeight() + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_light_list,
        el_available_lights,
        el_confirm
    );
    
    return dg;
}