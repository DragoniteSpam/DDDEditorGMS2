/// @param SelectionCircle
function selection_render_circle(argument0) {

    var selection = argument0;

    transform_set(0, 0, selection.z * TILE_DEPTH + 1, 0, 0, 0, 1, 1, 1);

    var precision = 24;
    var step = 360 / precision;
    var cx = selection.x * TILE_WIDTH;
    var cy = selection.y * TILE_HEIGHT;
    var cz = selection.z * TILE_DEPTH;
    var rw = selection.radius * TILE_WIDTH;
    var rh = selection.radius * TILE_HEIGHT;
    var rd = selection.radius * TILE_DEPTH;
    var w = 12;

    for (var i = 0; i < precision; i++) {
        var angle = i * step;
        var angle2 = (i + 1) * step;
        draw_line_width_colour(cx + rw * dcos(angle), cy - rh * dsin(angle), cx + rw * dcos(angle2), cy - rh * dsin(angle2), w, c_red, c_red);
    }

    transform_reset();


}
