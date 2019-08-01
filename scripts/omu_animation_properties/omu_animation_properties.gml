/// @param UIThing

var thing = argument0;
var animation = thing.root.active_animation;

if (animation) {
    var dw = 640;
    var dh = 360;

    var dg = dialog_create(dw, dh, "Animation Properties", undefined, undefined, argument0);
    
    var columns = 2;
    var ew = (dw - 64) / columns;
    var eh = 24;
    
    var vx1 = ew / 2 + 16;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy = 64;
    var yy_base = yy;
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
    
    var el_clear = create_button(16, yy, "Clear Keyframes After End", ew, eh, fa_center, null, dg);
    
    yy = yy + el_seconds.height + spacing;
    
    yy = yy_base;
    
    var el_explanation = create_text(dg.width / 2 + 16, dg.height / 2 - 16, "The moment rate only determines how many keyframes you can use per second - the actual animation will play at the same speed as the game (probably 60 fps).\n\nIf you shorten an animation, any keyframes after the end will continue to exist, they'll just be in accessible unless you add time back. If you want to get rid of them, click the button.", ew, eh, fa_left, ew, dg);
    yy = yy + el_explanation.height + spacing;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents, el_name, el_internal_name, el_frame_rate, el_moments, el_seconds, el_clear, el_explanation,
        el_confirm);

    keyboard_string = "";
}