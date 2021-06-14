/// @param UIButton
function ui_particle_type_remove(argument0) {

    var button = argument0;
    var selection = ui_list_selection(button.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[selection];
    
        for (var i = 0; i < ds_list_size(Stuff.particle.emitters); i++) {
            var emitter = Stuff.particle.emitters[| i];
            emitter.type = (emitter.type == type) ? noone : emitter.type;
        }
    
        instance_activate_object(type);
        instance_destroy(type);
        ds_list_delete(Stuff.particle.types, selection);
        ui_list_deselect(button.root.list);
    }


}
