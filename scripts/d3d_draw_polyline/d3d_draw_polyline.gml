// Feather disable all
/// @desc Function Description
/// @param {Array<struct>} points An array of (x, y, z) points; you can also provide "color" and "alpha" values to handle, uhh, color and alpha
/// @param {real} [radius] The radius of the line (defaults to 4)
/// @param {real} [default_color] The default color for line segments that don't have color values (defaults to c_white)
/// @param {real} [default_alpha] The default alpha for line segments that don't have alpha values (defaults to 1)
/// @param {boolean} [draw_end_caps] draw the end caps of the capsule of the line segment? for skinny lines they don't contribute much and can usually be turned off to save performance
function d3d_draw_polyline(points, radius = 4, default_color = draw_get_color(), default_alpha = draw_get_alpha(), draw_end_caps = false) {
    for (var i = 1, n = array_length(points); i < n; i++) {
        var p0 = points[i - 1];
        var p1 = points[i];
        var c0 = p0[$ "color"] ?? default_color;
        var c1 = p1[$ "color"] ?? default_color;
        var a0 = p0[$ "alpha"] ?? default_alpha;
        var a1 = p1[$ "alpha"] ?? default_alpha;
        d3d_draw_line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z, radius, c0, a0, c1, a1);
    }
}