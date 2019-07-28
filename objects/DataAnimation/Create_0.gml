event_inherited();

// list of Layer objects with priority queues of Keyframe objects
layers = ds_list_create();
var base_layer = instantiate(DataAnimLayer);
instance_deactivate_object(base_layer);
base_layer.is_actor = true;
ds_list_add(layers, base_layer);

frames_per_second = 24;
moments = frames_per_second * 2;

repeat (moments) {
    ds_list_add(base_layer.keyframes, noone);
}

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(0, 9);

ds_list_set(base_layer.keyframes, kf.moment, kf);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(10, 19);

ds_list_set(base_layer.keyframes, kf.moment, kf);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(20, 29);

ds_list_set(base_layer.keyframes, kf.moment, kf);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(30, 39);

ds_list_set(base_layer.keyframes, kf.moment, kf);