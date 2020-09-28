/// @param EditorMode
/// @param [camera-controls?]
function draw_editor_menu() {
    var mode = argument[0];
    var camera_controls = (argument_count > 1) ? argument[1] : false;
    
    // if you're using this in debug mode the overlay is going to be
    // shown and that's going to block out the first part of the menu
    var yy = DEBUG ? 24 : 0;
    
    var camera = view_get_camera(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(room_width / 2, room_height / 2, -16000,  room_width / 2, room_height / 2, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(room_width, room_height, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
    
    if (camera_controls) {
        draw_camera_controls_overlay(mode);
    }
    
    gpu_set_cullmode(cull_noculling);
    
    script_execute(Stuff.menu.render, Stuff.menu, 0, yy);
    
    // these are going to be uncommon and short-lived, so don't bother deactivating them.
    with (UINotification) {
        script_execute(render);
    }
    
    if (DEBUG) {
        draw_set_halign(fa_left);
        draw_rectangle_colour(0, 0, room_width, yy, false, c_white, c_white, c_white, c_white);
        draw_text_colour(64 * 0 + 16, yy / 2, "FPS: " + string(fps), c_black, c_black, c_black, c_black, 1);
        draw_text_colour(64 * 2 + 16, yy / 2, "Instant: " + string(fps_real), c_black, c_black, c_black, c_black, 1);
        draw_text_colour(64 * 4 + 16, yy / 2, "Average: " + string(Stuff.frames / Stuff.time), c_black, c_black, c_black, c_black, 1);
        draw_text_colour(64 * 6 + 16, yy / 2, "Compiled: " + Stuff.tf[code_is_compiled()], c_black, c_black, c_black, c_black, 1);
    }
}