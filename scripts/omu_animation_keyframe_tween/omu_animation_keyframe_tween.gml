function omu_animation_keyframe_tween(element) {
    var keyframe = element.root.root.el_timeline.selected_keyframe;
    var param = element.parameter;
    
    if (keyframe) {
        var dw = 320;
        var dh = 720;
        
        var dg = dialog_create(dw, dh, "Animation Tweening", undefined, undefined, argument0);
        
        var columns = 1;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy = 64;
        
        var el_type = create_radio_array(16, yy, "Type", ew, eh, uivc_animation_keyframe_set_tween, keyframe.GetParameterTween(param), dg);
        create_radio_array_options(el_type, global.animation_tween_names);
        el_type.param = param;
    
        var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

        ds_list_add(dg.contents,
            el_type,
            el_confirm
        );
    }
}