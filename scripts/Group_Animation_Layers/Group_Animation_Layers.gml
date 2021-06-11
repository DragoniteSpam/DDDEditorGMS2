function animation_get_next_keyframe(animation, timeline_layer, moment) {    
    for (var i = moment + 1; i < animation.moments; i++) {
        var keyframe = animation_get_keyframe(animation, timeline_layer, i);
        if (keyframe) {
            // @gml update lightweight objects maybe?
            return keyframe;
        }
    }
    
    return noone;
}

function animation_get_layer(animation, layer) {
    if (layer < array_length(animation.layers)) {
        return animation.layers[layer];
    }
    
    return undefined;
}

function animation_get_preivous_keyframe(animation, timeline_layer, moment) {
    for (var i = moment - 1; i >= 0; i--) {
        var keyframe = animation_get_keyframe(animation, timeline_layer, i);
        if (keyframe) {
            // @gml update lightweight objects maybe?
            return keyframe;
        }
    }
    
    return noone;
}

function animation_timeline_set_active_keyframe(timeline, keyframe) {
    timeline.selected_keyframe = keyframe;
    
    if (keyframe) {
        var keyframe_panel = timeline.root.el_keyframe;
        ui_input_set_value(keyframe_panel.translate_x, string(keyframe.xx));
        ui_input_set_value(keyframe_panel.translate_y, string(keyframe.yy));
        ui_input_set_value(keyframe_panel.translate_z, string(keyframe.zz));
        ui_input_set_value(keyframe_panel.rotate_x, string(keyframe.xrot));
        ui_input_set_value(keyframe_panel.rotate_y, string(keyframe.yrot));
        ui_input_set_value(keyframe_panel.rotate_z, string(keyframe.zrot));
        ui_input_set_value(keyframe_panel.scale_x, string(keyframe.xscale));
        ui_input_set_value(keyframe_panel.scale_y, string(keyframe.yscale));
        ui_input_set_value(keyframe_panel.scale_z, string(keyframe.zscale));
        keyframe_panel.color.value = keyframe.color;
        ui_input_set_value(keyframe_panel.alpha, string(keyframe.alpha));
        // events can't be tweened, and the UI is just a button
    }
}