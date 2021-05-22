/// @param UIButton
function ui_particle_type_sprite(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[| selection];
    
        var dw = 320;
        var dh = 540;
    
        var dg = dialog_create(dw, dh, "Particle Sprite", dialog_default, dialog_destroy, button);
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
    
        var el_update_list = create_list(col1_x, yy, "Particle Sprites", "<no particle sprites>", ew, eh, 10, ui_particle_type_sprite_assign, false, dg, Stuff.all_graphic_particles);
        var sprite = guid_get(type.sprite);
        ui_list_select(el_update_list, ds_list_find_index(Stuff.all_graphic_particles, sprite), true);
        el_update_list.tooltip = "The custom sprite to be used by the particle type. Go to Data > Graphics > Particles to manage particle sprites. When you import the generated code into your game, make sure your project has a sprite with the same Internal Name as the sprite used here.";
        el_update_list.entries_are = ListEntries.INSTANCES;
    
        yy += ui_get_list_height(el_update_list) + spacing;
    
        var el_animated = create_checkbox(col1_x, yy, "Animated?", ew, eh, ui_particle_type_sprite_animated, type.sprite_animated, dg);
        el_animated.tooltip = "Should the particles follow the sprite's animation?";
    
        yy += el_animated.height + spacing;
    
        var el_stretched = create_checkbox(col1_x, yy, "Animation stretched?", ew, eh, ui_particle_type_sprite_stretched, type.sprite_stretched, dg);
        el_stretched.tooltip = "Should the particle's animation be stretched out over the lifespan of the particle, or play at a rate of one frame per step?";
    
        yy += el_stretched.height + spacing;
    
        var el_random = create_checkbox(col1_x, yy, "Random subimage?", ew, eh, ui_particle_type_sprite_random, type.sprite_random, dg);
        el_random.tooltip = "Should the particles start with a random subimage of the sprite?";
    
        yy += el_random.height + spacing;
    
        var b_width = 128;
        var b_height = 32;
        var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dialog_destroy, dg);

        ds_list_add(dg.contents,
            el_update_list,
            el_animated,
            el_stretched,
            el_random,
            el_confirm
        );

        return dg;
    }


}
