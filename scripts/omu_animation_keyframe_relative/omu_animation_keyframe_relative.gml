/// @param UIThing

var thing = argument0;
var keyframe = thing.root.root.el_timeline.selected_keyframe;

if (keyframe) {
    // keyframe is guaranteed to have a value
    var dw = 320;
    var dh = 480;

    var dg = dialog_create(dw, dh, "Keyframe Relative To Other Layer", undefined, undefined, argument0);
    
    var columns = 1;
    var ew = (dw - 64) / columns;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var col2_x = dw / columns;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
    var spacing = 16;
    
    var el_list = create_list(16, yy, "Other Layer", "No Layers", ew, eh, 12, uivc_animation_keyframe_relative, false, dg);
    for (var i = 0; i < ds_list_size(thing.root.root.active_animation.layers); i++) {
        create_list_entries(el_list, thing.root.root.active_animation.layers[| i].name);
    }
    ds_map_add(el_list.selected_entries, keyframe.relative, true);
    // i should probably be doing this in more places so that i can find stuff easily
    el_list.keyframe = keyframe;

    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents, el_list,
        el_confirm);
}