/// @param UIThing

var thing = argument0;
var list = thing.root.active_animation.layers;

var selection = ui_list_selection(thing.root.el_layers);

if (ds_list_size(list) > 0 && thing.root.active_animation && selection >= 0) {
    instance_activate_object(list[| selection]);
    instance_destroy(list[| selection]);
    ds_list_delete(list, selection);
    ui_list_deselect(thing.root.el_layers);
}