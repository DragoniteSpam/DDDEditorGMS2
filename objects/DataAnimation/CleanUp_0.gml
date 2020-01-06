event_inherited();

for (var i = 0; i < ds_list_size(layers); i++) {
    var timeline_layer = layers[| i];
    instance_activate_object(timeline_layer);
    instance_destroy(timeline_layer);
}

ds_list_destroy(layers);