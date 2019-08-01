/// @param UIThing

var thing = argument0;
var animation = thing.root.active_animation;

if (animation) {
    var dw = 320;
    var dh = 320;

    var dg = dialog_create(dw, dh, "Animation Properties", undefined, undefined, argument0);
    
    var ew = dw - 64;
    var eh = 24;
    
    var vx1 = ew / 2 + 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var spacing = 16;
    
    var el_name = create_input(16, yy, "Name:", ew, eh, uivc_animation_set_name, 0, animation.name, "text", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
    
    yy = yy + el_name.height + spacing;
    
    var el_internal_name = create_input(16, yy, "Internal Name:", ew, eh, uivc_animation_set_internal_name, 0, animation.internal_name, "Internal name", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_internal_name.render = ui_render_text_animation_internal_name;
    
    yy = yy + el_internal_name.height + spacing;
    
    var el_frame_rate = create_input(16, yy, "Moment rate:", ew, eh, uivc_animation_set_frame_rate, 0, string(animation.frames_per_second), "integer", validate_int, ui_value_real, 1, 96, 2, vx1, vy1, vx2, vy2, dg);
    
    yy = yy + el_frame_rate.height + spacing;
    
    var el_moments = create_input(16, yy, "Moments:", ew, eh, uivc_animation_set_moments, 0, string(animation.moments), "integer", validate_int, ui_value_real, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
    
    yy = yy + el_moments.height + spacing;
    
    var el_seconds = create_text(16, yy, "Duration (seconds): " + string(animation.moments / animation.frames_per_second), ew, eh, fa_left, ew, dg);
    dg.el_seconds = el_seconds;
    yy = yy + el_seconds.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_name, el_internal_name, el_frame_rate, el_moments, el_seconds,
        el_confirm);

    keyboard_string = "";
}