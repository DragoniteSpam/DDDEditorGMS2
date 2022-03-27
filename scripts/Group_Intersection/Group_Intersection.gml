function mouse_within_rectangle(x1, y1, x2, y2) {
    return point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2);
}

function node_on_screen(view, x1, y1, x2, y2) {
    // to do: this function is exclusively used in draw_event_node to make sure
    // an event node is on screen before drawing it (it was previously called
    // rectangle_within_view)
    return true;
    //var camera = view_get_camera(view);
    //return rectangle_in_rectangle(x1, y1, x2, y2, camera_get_view_x(camera), camera_get_view_y(camera), camera_get_view_x(camera) + camera_get_view_width(camera), camera_get_view_y(camera) + camera_get_view_height(camera));
}