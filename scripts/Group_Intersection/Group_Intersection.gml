function mouse_within_rectangle(x1, y1, x2, y2) {
    return point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2);
}

function mouse_within_rectangle_adjusted(x1, y1, x2, y2) {
    // for when a view x y isn't set at (0, 0) and you need things to be offset
    var camera = view_get_camera(view_current);
    var xoff = camera_get_view_x(camera);
    var yoff = camera_get_view_y(camera);
    return mouse_within_rectangle(x1 - xoff, y1 - yoff, x2 - xoff, y2 - yoff);
}

function mouse_within_rectangle_determine(x1, y1, x2, y2, adjusted) {
    return adjusted ? mouse_within_rectangle_adjusted(x1, y1, x2, y2) : mouse_within_rectangle_view(x1, y1, x2, y2);
}

function mouse_within_rectangle_view(x1, y1, x2, y2) {
    return point_in_rectangle(mouse_x_view, mouse_y_view, x1, y1, x2, y2);
}

function mouse_within_view(view) {
    return point_within_view(view, mouse_x, mouse_y);
}

function point_within_view(view, x, y) {
    return point_in_rectangle(x, y, view_get_xport(view), view_get_yport(view), view_get_xport(view) + view_get_wport(view), view_get_yport(view) + view_get_hport(view));
}

function rectangle_within_view(view, x1, y1, x2, y2) {
    var camera = view_get_camera(view);
    return rectangle_in_rectangle(x1, y1, x2, y2, camera_get_view_x(camera), camera_get_view_y(camera), camera_get_view_x(camera) + camera_get_view_width(camera), camera_get_view_y(camera) + camera_get_view_height(camera));
}