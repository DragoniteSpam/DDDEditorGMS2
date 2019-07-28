name = "Layer 0";
is_actor = false;

// list of Keyframes - the game would prefer this to be a priority queue
// but we need to randomly access them so they're not
keyframes = ds_list_create();