/// @param SelectionSingle

var selection = argument0;

//transform_set(0, 0, selection.z * TILE_DEPTH + 1, 0, 0, 0, 1, 1, 1);

var x1 = selection.x * TILE_WIDTH;
var y1 = selection.y * TILE_HEIGHT;
var x2 = (selection.x + 1) * TILE_WIDTH;
var y2 = (selection.y + 1) * TILE_HEIGHT;
var z1 = selection.z * TILE_DEPTH;
var z2 = (selection.z + 1) * TILE_DEPTH;

/*var w = 12;

draw_line_width_colour(x1, y1, x1, y2, w, c_red, c_red);
draw_line_width_colour(x1, y1, x2, y1, w, c_red, c_red);
draw_line_width_colour(x2, y1, x2, y2, w, c_red, c_red);
draw_line_width_colour(x1, y2, x2, y2, w, c_red, c_red);
transform_reset();*/

shader_set(shd_bounding_box);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 0]);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
    x1, y1, z1,
    x1, y1, z2,
    x1, y2, z1,
    z1, y2, z2,
    x2, y1, z1,
    x2, y1, z2,
    x2, y2, z1,
    z2, y2, z2,
]);
The vertices are not appearing in the right place, which usually means the math is wrong
vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
shader_reset();