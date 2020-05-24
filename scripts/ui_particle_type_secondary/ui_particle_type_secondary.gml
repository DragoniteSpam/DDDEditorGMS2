/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    
    var dw = 640;
    var dh = 480;
    
    var dg = dialog_create(dw, dh, "Secondary Emission", dialog_default, dc_close_no_questions_asked, button);
    dg.type = type;
    
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
    var yy_base = yy;
    
    var el_update_list = create_list(col1_x, yy, "Update", "", ew, eh, 10, null, false, dg, Stuff.particle.types);
    ui_list_select(el_update_list, ds_list_find_index(Stuff.particle.types, type.update_type), true);
    el_update_list.entries_are = ListEntries.INSTANCES;
    
    yy += ui_get_list_height(el_update_list) + spacing;
    
    var el_update_rate = create_input(col1_x, yy, "Rate:", ew, eh, null, type.update_count, "particles per second", validate_double, 0, 1000, 6, vx1, vy1, vx2, vy2, dg);
    
    yy = yy_base;
    
    var el_death_list = create_list(col2_x, yy, "Death", "", ew, eh, 10, null, false, dg, Stuff.particle.types);
    ui_list_select(el_death_list, ds_list_find_index(Stuff.particle.types, type.death_type), true);
    el_death_list.entries_are = ListEntries.INSTANCES;
    
    yy += ui_get_list_height(el_death_list) + spacing;
    
    var el_death_rate = create_input(col2_x, yy, "Count:", ew, eh, null, type.death_count, "particles per second", validate_double, 0, 1000, 6, vx1, vy1, vx2, vy2, dg);
    
    yy += el_death_rate.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);

    ds_list_add(dg.contents,
        el_update_list,
        el_update_rate,
        el_death_list,
        el_death_rate,
        el_confirm
    );

    return dg;
}