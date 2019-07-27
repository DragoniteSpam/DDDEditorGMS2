name = "Layer 0";
is_actor = false;

// priority queues of Keyframes
keyframes = ds_priority_create();

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(0, 9);

ds_priority_add(keyframes, kf, kf.moment);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(10, 19);

ds_priority_add(keyframes, kf, kf.moment);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(20, 29);

ds_priority_add(keyframes, kf, kf.moment);

var kf = instantiate(DataAnimKeyframe);
kf.moment = irandom_range(30, 39);

ds_priority_add(keyframes, kf, kf.moment);