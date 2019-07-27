/// @param UIThing

var thing = argument0;

if (thing.root.active_animation) {
    if (ds_list_size(thing.root.active_animation.layers) < 250) {
        var timeline_layer = instantiate(DataAnimLayer);
        var n = string(ds_list_size(thing.root.active_animation.layers));;
        timeline_layer.name = "Layer " + n;
        instance_deactivate_object(timeline_layer);
        ui_list_deselect(thing.root.el_layers);
        ds_list_add(thing.root.active_animation.layers, timeline_layer);
    } else {
        dialog_create_notice(thing.root, "Please don't try to create more than 250 animations.", "Hey!");
    }
}