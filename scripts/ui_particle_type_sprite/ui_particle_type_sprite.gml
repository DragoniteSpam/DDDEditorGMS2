/// @param UIButton

var button = argument0;
var selection = ui_list_selection(button.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    
    var dw = 320;
    var dh = 540;
    
    var dg = dialog_create(dw, dh, "Particle Sprite", dialog_default, dc_close_no_questions_asked, button);
    dg.type = type;
    dg.active_shade = false;
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var col1_x = dw * 0 / columns + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    var yy_base = yy;
    
    //var el_update_list = create_list(col1_x, yy, "Particle SPrites", "", ew, eh, 10, ui_particle_type_secondary_update_type, false, dg, Stuff.particle.types);
    var el_update_list = create_list(col1_x, yy, "Particle Sprites", "<no particle sprites>", ew, eh, 10, null, false, dg, Stuff.all_graphic_particles);
    ui_list_select(el_update_list, ds_list_find_index(Stuff.all_graphic_particles, type.sprite), true);
    el_update_list.tooltip = "The custom sprite to be used by the particle type. Go to Data > Graphics > Particles to manage particle sprites. Right-click the list to deselect.";
    el_update_list.entries_are = ListEntries.INSTANCES;
    
    yy += ui_get_list_height(el_update_list) + spacing;
    
    var el_animated = create_checkbox(col1_x, yy, "Animated?", ew, eh, null, false, dg);
    
    yy += el_animated.height + spacing;
    
    var el_stretched = create_checkbox(col1_x, yy, "Animation stretched?", ew, eh, null, false, dg);
    
    yy += el_stretched.height + spacing;
    
    var el_random = create_checkbox(col1_x, yy, "Random subimage?", ew, eh, null, false, dg);
    
    yy += el_random.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);

    ds_list_add(dg.contents,
        el_update_list,
        el_animated,
        el_stretched,
        el_random,
        el_confirm
    );

    return dg;
}