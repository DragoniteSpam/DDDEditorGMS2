function ui_particle_type_secondary_death_type(list) {
    var selection = ui_list_selection(list);
    var type = list.root.type;
    
    if (selection + 1) {
        var emissive_type = Stuff.particle.types[| selection];
        while (emissive_type) {
            if (emissive_type == type) {
                emu_dialog_notice("Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                ui_list_deselect(list);
                ui_list_select(list, ds_list_find_index(Stuff.particle.types, type.death_type), false);
                return;
            }
            if (emissive_type == emissive_type.update_type) break;
            emissive_type = emissive_type.update_type;
        }
        
        emissive_type = Stuff.particle.types[| selection];
        while (emissive_type) {
            if (emissive_type == type) {
                dialog_create_notice(list.root, "Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                ui_list_deselect(list);
                ui_list_select(list, ds_list_find_index(Stuff.particle.types, type.death_type), false);
                return;
            }
            if (emissive_type == emissive_type.death_type) break;
            emissive_type = emissive_type.death_type;
        }
        
        type.death_type = Stuff.particle.types[| selection];
        part_type_death(type.type, type.death_rate, type.death_type.type);
    } else {
        type.death_type = noone;
        part_type_death(type.type, 0, -1);
    }
}