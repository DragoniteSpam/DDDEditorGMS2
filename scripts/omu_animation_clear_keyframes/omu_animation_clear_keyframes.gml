function omu_animation_clear_keyframes(button) {
    var animation = button.root.root.root.active_animation;
    
    // we can safely assume animation exists if we got to this point
    var n = 0;
    for (var i = 0; i < ds_list_size(animation.layers); i++) {
        var timeline_layer = animation.layers[| i];
        for (var j = animation.moments; j < array_length(timeline_layer.keyframes); j++) {
            if (timeline_layer.keyframes[j]) {
                n++;
            }
        }
    }
    if (n == 0) {
        emu_dialog_notice("There are no out-of-bounds keyframes in this animation. You don't have to worry!");
    } else {
        var msg = (n > 1) ? "There are " + string(n) + " out-of-bounds keyframes in this animation. Would you like to get rid of them?" : "There is 1 out-of-bounds keyframe in this animation. Would you like to get rid of it?";
        emu_dialog_confirm(button, msg, function() {
            // everything is terrible
            var animation = self.root.root.root.root.root.active_animation;
            // we can safely assume animation exists if we got to this point
            for (var i = 0; i < ds_list_size(animation.layers); i++) {
                var timeline_layer = animation.layers[| i];
                for (var j = animation.moments; j < array_length(timeline_layer.keyframes); j++) {
                    timeline_layer.keyframes[j] = undefined;
                }
            }
            self.root.Dispose();
        });
    }
}