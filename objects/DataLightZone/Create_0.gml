event_inherited();

var map = Stuff.map.active_map;
var map_contents = map.contents;

save_script = serialize_save_zone_light;
load_script = serialize_load_zone_light;
zone_edit_script = function(root) {
    var zone = Stuff.map.selected_zone;
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    var dw = 960;
    var dh = 480;
    
    var dg = dialog_create(dw, dh, "Light Zone Settings: " + zone.name, dialog_default, dialog_destroy, root);
    dg.zone = zone;
    
    var columns = 3;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / columns + spacing;
    var col2_x = dw * 1 / columns + spacing;
    var col3_x = dw * 2 / columns + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    
    var el_name = create_input(col1_x, yy, "Name", ew, eh, uivc_input_map_zone_name, zone.name, "name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "A name; this is for identification (and possibly debugging) purposes and has no influence on gameplay";
    yy += el_name.height + spacing;
    
    var yy_base = yy;
    
    var el_bounds_text = create_text(col1_x, yy, "Bounds", ew, eh, fa_left, ew, dg);
    el_bounds_text.color = c_blue;
    
    yy += el_bounds_text.height + spacing;
    
    var bounds_x_help = "0..." + string(map.xx);
    var bounds_y_help = "0..." + string(map.yy);
    var bounds_z_help = "0..." + string(map.zz);
    
    var el_bounds_x1 = create_input(col1_x, yy, "X1:", ew, eh, uivc_input_map_zone_x1, zone.x1, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_x1.tooltip = "The starting X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_x1.height + spacing;
    
    var el_bounds_y1 = create_input(col1_x, yy, "Y1:", ew, eh, uivc_input_map_zone_y1, zone.y1, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_y1.tooltip = "The starting Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_y1.height + spacing;
    
    var el_bounds_z1 = create_input(col1_x, yy, "Z1:", ew, eh, uivc_input_map_zone_z1, zone.z1, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_z1.tooltip = "The starting Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_z1.height + spacing;
    
    var el_bounds_x2 = create_input(col1_x, yy, "X2:", ew, eh, uivc_input_map_zone_x2, zone.x2, bounds_x_help, validate_int, 0, map.xx, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_x2.tooltip = "The ending X coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_x2.height + spacing;
    
    var el_bounds_y2 = create_input(col1_x, yy, "Y2:", ew, eh, uivc_input_map_zone_y2, zone.y2, bounds_y_help, validate_int, 0, map.yy, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_y2.tooltip = "The ending Y coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_y2.height + spacing;
    
    var el_bounds_z2 = create_input(col1_x, yy, "Z2:", ew, eh, uivc_input_map_zone_z2, zone.z2, bounds_z_help, validate_int, 0, map.zz, 4, vx1, vy1, vx2, vy2, dg);
    el_bounds_z2.tooltip = "The ending Z coordinate of the camera zone. If the minimum and maximum bounds values are switched, the editor will automatically put them in order.";
    yy += el_bounds_z2.height + spacing;
    
    yy = yy_base;
    
    var el_light_list = create_list(col2_x, yy, "Active Lights:", "<no active lights>", ew, eh, 12, function(list) {
        var all_list = list.root.el_available_lights;
        var active_selection = ui_list_selection(active_list);
        var all_selection = ui_list_selection(all_list);
        if (active_selection + 1) {
            ui_list_deselect(all_list);
            ui_list_select(all_list, ds_list_find_index(all_list.entries, active_list.entries[active_selection]), true);
        }
    }, false, dg, zone.active_lights);
    el_light_list.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. Effects with no light component (i.e. the light component has been removed) will be shown in red. Duplicate entries will be shown in orange. I recommend giving, at the very least, all of your Light entities unique names. One light will be reserved for the player at all times.";
    el_light_list.render_colors = ui_list_color_effect_components;
    el_light_list.entries_are = ListEntries.REFIDS;
    dg.el_light_list = el_light_list;
    yy += ui_get_list_height(el_light_list) + spacing;
    
    yy = yy_base;
    
    var el_available_lights = create_list(col3_x, yy, "Available Lights:", "<no available lights>", ew, eh, 12, function(list) {
        var active_list = list.root.el_light_list;
        var selection = ui_list_selection(list);
        var active_selection = ui_list_selection(active_list);
        if (active_selection + 1) {
            if (selection + 1) {
                active_list.entries[| active_selection] = list.entries[| selection];
            } else {
                active_list.entries[| active_selection] = 0;
            }
        }
    }, false, dg);
    el_available_lights.tooltip = "Directional lights will be shown in green. Point lights will be shown in blue. I recommend giving, at the very least, all of your Light entities unique names. Deselecting this list will clear the active light index.";
    el_available_lights.entries_are = ListEntries.REFIDS;
    for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
        var entity = map_contents.all_entities[| i];
        if (instanceof_classic(entity, EntityEffect) && entity.com_light) {
            create_list_entries(el_available_lights, [entity.REFID, entity.com_light.label_colour]);
        }
    }
    dg.el_available_lights = el_available_lights;
    
    yy += ui_get_list_height(el_available_lights) + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_commit = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_name,
        el_bounds_text,
        el_bounds_x1,
        el_bounds_y1,
        el_bounds_z1,
        el_bounds_x2,
        el_bounds_y2,
        el_bounds_z2,
        el_light_list,
        el_available_lights,
        el_commit
    );
    
    return dg;
};
editor_color = c_yellow;

/* s */ name = "LightZone " + name;
/* s */ ztype = MapZoneTypes.LIGHT;

/* s */ active_lights = array_create(MAX_LIGHTS, NULL);

CreateJSONZoneLights = function() {
    var json = self.CreateJSONZone();
    json.lights = {
        data: self.active_lights,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONZoneLights();
};