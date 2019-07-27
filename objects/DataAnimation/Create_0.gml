event_inherited();

// list of Layer objects of priority queues of Keyframe objects
layers = ds_list_create();
var base_layer = instantiate(DataAnimLayer);
instance_deactivate_object(base_layer);
ds_list_add(layers, base_layer);