/// @param UIList
function ui_particle_type_secondary_update_type(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);
    var type = list.root.type;

    if (selection + 1) {
        var emissive_type = Stuff.particle.types[| selection];
        while (emissive_type) {
            if (emissive_type == type) {
                dialog_create_notice(list.root, "Please don't recursively create particles. This will most likely slow down the editor and cause it to crash within seconds.");
                ui_list_deselect(list);
                ui_list_select(list, ds_list_find_index(Stuff.particle.types, type.update_type), false);
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
                ui_list_select(list, ds_list_find_index(Stuff.particle.types, type.update_type), false);
                return;
            }
            if (emissive_type == emissive_type.death_type) break;
            emissive_type = emissive_type.death_type;
        }
    
        type.update_type = Stuff.particle.types[| selection];
        part_type_step(type.type, type.update_rate * Stuff.dt, type.update_type.type);
    } else {
        type.update_type = noone;
        part_type_step(type.type, 0, -1);
    }


}
