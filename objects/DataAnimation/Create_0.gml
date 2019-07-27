event_inherited();

// list of Layer objects with priority queues of Keyframe objects
layers = ds_list_create();
var base_layer = instantiate(DataAnimLayer);
instance_deactivate_object(base_layer);
base_layer.is_actor = true;
ds_list_add(layers, base_layer);

frames_per_second = 24;
moments = frames_per_second * 1;