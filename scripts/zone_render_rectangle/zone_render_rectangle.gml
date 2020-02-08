/// @param DataCameraZone
// not technically a selection render, but it works very similarly so i'm going
// to lump it in with them

var zone = argument0;

var minx = min(zone.x1, zone.x2);
var miny = min(zone.y1, zone.y2);
var minz = min(zone.z1, zone.z2);
var maxx = max(zone.x2, zone.x2);
var maxy = max(zone.y2, zone.y2);
var maxz = max(zone.z2, zone.z2);

var x1 = minx * TILE_WIDTH;
var y1 = miny * TILE_HEIGHT;
var z1 = minz * TILE_DEPTH;
// the outer corner of the cube is already at (32, 32, 32) so we need to
// compensate for that
var cube_bound = 32;
var x2 = maxx * TILE_WIDTH - cube_bound;
var y2 = maxy * TILE_HEIGHT - cube_bound;
var z2 = maxz * TILE_DEPTH - cube_bound;
var zone_color = (Stuff.map.selected_zone == zone) ? c_array_zone_selected : zone.editor_color;

shader_set(shd_bounding_box);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), zone_color);
shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
    x1, y1, z1,
    x2, y1, z1,
    x1, y2, z1,
    x2, y2, z1,
    x1, y1, z2,
    x2, y1, z2,
    x1, y2, z2,
    x2, y2, z2,
]);

vertex_submit(Stuff.graphics.indexed_cage_full, pr_trianglelist, -1);
shader_reset();