/// @param SelectionSingle

var selection = argument0;

var x1 = selection.x * TILE_WIDTH;
var y1 = selection.y * TILE_HEIGHT;
var z1 = selection.z * TILE_DEPTH;
var x2 = x1;
var y2 = y1;
var z2 = z1;

shader_set(shd_bounding_box);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
    x1, y1, z1,
    x1, y1, z2,
    x1, y2, z1,
    x1, y2, z2,
    x2, y1, z1,
    x2, y1, z2,
    x2, y2, z1,
    x2, y2, z2,
]);

vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
shader_reset();