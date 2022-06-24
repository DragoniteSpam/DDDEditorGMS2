function draw_editor_event() {
    var controller_left = Controller.mouse_left;
    var controller_right = Controller.mouse_right;
    var controller_middle = Controller.mouse_middle;
    
    var controller_press_left = Controller.press_left;
    var controller_press_right = Controller.press_right;
    var controller_press_middle = Controller.press_middle;
    
    var controller_release_left = Controller.release_left;
    var controller_release_right = Controller.release_right;
    var controller_release_middle = Controller.release_middle;
    
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    
    draw_set_color(c_white);
    draw_set_font(FDefault);
    draw_set_valign(fa_middle);
    
    var checker_width = sprite_get_width(b_tileset_checkers);
    var checker_height = sprite_get_height(b_tileset_checkers);
    
    var camera = camera_get_active();
    var xview = camera_get_view_x(camera);
    var yview = camera_get_view_y(camera);
    var wview = camera_get_view_width(camera);
    var hview = camera_get_view_height(camera);
    
    draw_checkerbox((xview div checker_width) * checker_width - checker_width,
        (yview div checker_height) * checker_height - checker_height, wview + checker_width * 2, hview + checker_height * 2
    );
    
    draw_active_event();
    
    draw_rectangle_colour(xview, yview + hview - 16, xview + wview, yview + hview, c_white, c_white, c_white, c_white, false);
    draw_text_colour(xview + 16, yview + hview - 8, string("Canvas at (" + string(xview) + ", " + string(yview) + "); mouse at (" +
        string(mouse_x) + ", " + string(mouse_y) + ")"), c_black, c_black, c_black, c_black, 1);
    
    if (CONTROL_3D_LOOK) {
        if (!dialog_exists()) {
            window_set_cursor(cr_none);
            draw_sprite(spr_scroll, 0, xview + mouse_x, yview + mouse_y);
        
            camera_set_view_pos(camera, xview - (mouse_x - Controller.mouse_x_previous), yview - (mouse_y - Controller.mouse_y_previous));
        }
    } else {
        window_set_cursor(cr_default);
    }
    
    if (request_cancel_active_node) {
        request_cancel_active_node = false;
        canvas_active_node = noone;
        canvas_active_node_index = 0;
    }
}