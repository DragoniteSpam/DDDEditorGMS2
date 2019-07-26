/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(thing.root.el_master);

if (selection >= 0) {
    for (var i = 0; i < ds_list_size(Stuff.all_animations); i++) {
        if (Stuff.all_animations[| i] == thing.root.active_animation) {
            ds_list_delete(Stuff.all_animations, i);
            instance_activate_object(thing.root.active_animation);
            instance_destroy(thing.root.active_animation);
            ui_list_deselect(thing.root.el_master);
            thing.root.active_animation = noone;
            thing.root.el_name.value = "";
            thing.root.el_internal_name.value = "";
            break;
        }
    }
}