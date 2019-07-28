/// @param timeline
/// @param keyframe

var timeline = argument0;
var keyframe = argument1;

timeline.selected_keyframe = keyframe;

if (keyframe) {
    var keyframe_panel = timeline.root.el_keyframe;
    keyframe_panel.translate_x.value = string(keyframe.xx);
    keyframe_panel.translate_y.value = string(keyframe.yy);
    keyframe_panel.translate_z.value = string(keyframe.zz);
    keyframe_panel.rotate_x.value = string(keyframe.xrot);
    keyframe_panel.rotate_y.value = string(keyframe.yrot);
    keyframe_panel.rotate_z.value = string(keyframe.zrot);
    keyframe_panel.scale_x.value = string(keyframe.xscale);
    keyframe_panel.scale_y.value = string(keyframe.yscale);
    keyframe_panel.scale_z.value = string(keyframe.zscale);
    //keyframe_panel.color.value = string(keyframe.color);
    // when color pickers are finally implemented, it'll be slightly different
    keyframe_panel.alpha.value = string(keyframe.alpha);
    // events can't be tweened, and the UI is just a button
}