function omu_event_attain_map_data(thing, event_node, data_index) {
    if (Stuff.map.active_map.data_buffer) buffer_delete(Stuff.map.active_map.data_buffer);
    Stuff.map.active_map.data_buffer = serialize_save_current_map();

    var dw = 1440;
    var dh = 800;

    // Hide the close button, because if the map preview stuff isn't deleted it'll just sit in memory
    // wasting space (although it won't leak because it'll be cleaned up next time this is opened)
    var dg = dialog_create(dw, dh, "Map Transfer", dialog_default, dc_close_destroy_map_preview, thing, noone);
    dg.node = event_node;
    dg.index = data_index;

    var custom_data_map = event_node.custom_data[0];
    var custom_data_x = event_node.custom_data[1];
    var custom_data_y = event_node.custom_data[2];
    var custom_data_z = event_node.custom_data[3];
    var custom_data_direction = event_node.custom_data[4];
    var custom_data_color = event_node.custom_data[5];
    var custom_data_time = event_node.custom_data[6];

    var map = guid_get(custom_data_map[0]);
    var map_contents = map.contents;

    var columns = 4;
    var ew = dw / columns - 32;
    var eh = 24;

    var c2 = dw / 4;
    var c3 = dw / 2;
    var c4 = dw * 3 / 4;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var yy = 64;
    var yy_start = yy;
    var spacing = 16;

    var el_maps = create_list(16, yy, "Maps", "no maps", ew, eh, 8, uivc_list_event_attain_map_index, false, dg, Game.maps);
    for (var i = 0; i < array_length(Game.maps); i++) {
        if (Game.maps[i] == map) {
            ui_list_select(el_maps, i);
            break;
        }
    }
    el_maps.allow_deselect = false;
    el_maps.entries_are = ListEntries.INSTANCES;
    dg.el_maps = el_maps;

    yy += el_maps.GetHeight() + spacing * 2;

    var el_text = create_text(16, yy, "Click on a location in one of the maps to set the destination", ew, eh, fa_left, ew, dg);

    yy += el_text.height + spacing * 2;

    var el_input_x = create_input(16, yy, "X", ew, eh, uivc_input_event_attain_transfer_x, custom_data_x[0], "", validate_int, 0, map.xx - 1, 5, vx1, vy1, vx2, vy2, dg);
    yy += el_input_x.height + spacing;
    dg.el_input_x = el_input_x;

    var el_input_y = create_input(16, yy, "Y", ew, eh, uivc_input_event_attain_transfer_y, custom_data_y[0], "", validate_int, 0, map.yy - 1, 5, vx1, vy1, vx2, vy2, dg);
    yy += el_input_y.height + spacing;
    dg.el_input_y = el_input_y;

    var el_input_z = create_input(16, yy, "Z", ew, eh, uivc_input_event_attain_transfer_z, custom_data_z[0], "", validate_int, 0, map.zz - 1, 5, vx1, vy1, vx2, vy2, dg);
    yy += el_input_z.height + spacing;
    dg.el_input_z = el_input_z;

    var el_direction = create_radio_array(16, yy, "Direction", ew, eh, uivc_list_event_attain_transfer_direction, custom_data_direction[0], dg);
    create_radio_array_options(el_direction, global.rpg_maker_directions);
    dg.el_direction = el_direction;
    yy += el_direction.GetHeight() + spacing;

    var el_color = create_color_picker(16, yy, "Fade Color", ew, eh, uivc_input_event_attain_transfer_color, custom_data_color[0], vx1, vy1, vx2, vy2, dg);
    dg.el_color = el_color;
    yy += el_color.height + spacing;

    var el_time = create_input(16, yy, "Fade Time", ew, eh, uivc_input_event_attain_transfer_time, custom_data_time[0], "seconds", validate_double, 0, 100, 5, vx1, vy1, vx2, vy2, dg);
    dg.el_time = el_time;

    yy = yy_start;

    var el_render = create_render_surface(c2 + 16, yy, dw * 3 / 4 - 32, dh - 96, ui_render_surface_render_map, ui_render_surface_control_map, c_black, dg);
    // let's be honest, if you somehow manage to make a data file with zero maps you
    // have bigger problems than the error this is going to generate
    var visible_map = guid_get(custom_data_map[| 0]);

    if (visible_map.preview) {
        vertex_delete_buffer(visible_map.preview);
        vertex_delete_buffer(visible_map.wpreview);
    }

    batch_all_preview(visible_map);

    Stuff.event.map = visible_map;

    var b_width = 128;
    var b_height = 32;
    var el_close = create_button(ew / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_maps, el_text, el_input_x, el_input_y, el_input_z, el_direction, el_render, el_color, el_time, el_close);

    return dg;


}

