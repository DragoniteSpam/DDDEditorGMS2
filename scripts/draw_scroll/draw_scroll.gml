var camera = view_get_camera(view_current);
draw_sprite(spr_scroll, 0, mouse_x_view - camera_get_view_x(camera), mouse_y_view - camera_get_view_y(camera));