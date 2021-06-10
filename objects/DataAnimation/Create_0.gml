event_inherited();

// list of Layer objects with priority queues of Keyframe objects
layers = ds_list_create();
var base_layer = new DataAnimationLayer("Layer 0");
base_layer.is_actor = true;
ds_list_add(layers, base_layer);

frames_per_second = 24;
moments = frames_per_second * 2;
loops = true;

code = Stuff.default_lua_animation;

repeat (moments) {
    ds_list_add(base_layer.keyframes, noone);
}

CreateJSONAnimation = function() {
    var json = self.CreateJSONBase();
    json.frames_per_second = self.frames_per_second;
    json.moments = self.moments;
    json.loops = self.loops;
    json.code = self.code;
    json.layers = array_create(ds_list_size(self.layers));
    for (var i = 0, n = ds_list_size(self.layers); i < n; i++) {
        json.layers[i] = self.layers[| i];
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONAnimation();
};