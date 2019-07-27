name = "Layer 0";
is_actor = false;

// priority queues of Keyframes
keyframes = ds_priority_create();

var kf = instantiate(DataAnimKeyframe);
kf.moment = choose(2, 3, 4);

ds_priority_add(keyframes, kf, kf.moment);

var kf = instantiate(DataAnimKeyframe);
kf.moment = choose(5, 6, 7);

ds_priority_add(keyframes, kf, kf.moment);

var kf = instantiate(DataAnimKeyframe);
kf.moment = choose(8, 9, 10);

ds_priority_add(keyframes, kf, kf.moment);