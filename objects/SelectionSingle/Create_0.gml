event_inherited();

z = 0;

// no drag because you can only ever select the cell you click on
onmousedown = function(selection, x, y, z) {
    selection.x = x;
    selection.y = y;
    selection.z = z;
    sa_process_selection();
};

area = function(selection) {
    return 1;
};

render = function(selection) {
    var xx = selection.x * TILE_WIDTH;
    var yy = selection.y * TILE_HEIGHT;
    var zz = selection.z * TILE_DEPTH;
    
    shader_set(shd_bounding_box);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
        xx, yy, zz,
    ]);
    
    vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
    shader_reset();
};

onmove = function(selection, dx, dy, dz) {
    var map = Stuff.map.active_map;
    selection.x = clamp(selection.x + dx, 0, map.xx - 1);
    selection.y = clamp(selection.y + dy, 0, map.yy - 1);
    selection.z = clamp(selection.z + dz, 0, map.zz - 1);
};

foreach_cell = function(selection, processed, script, params) {
    var str = string(selection.x) + "," + string(selection.y) + "," + string(selection.z);
    if (!ds_map_exists(processed, str)) {
        ds_map_add(processed, str, true);
        script(selection.x, selection.y, selection.z, params);
    }
};

selected_determination = function(selection, entity) {
    return (selection.x == entity.xx && selection.y == entity.yy) && (!Stuff.map.active_map.is_3d || selection.z == entity.zz);
};
selected_border_determination = function(selection, entity) {
    var minx = selection.x - 1;
    var miny = selection.y - 1;
    var minz = selection.z - 1;
    var maxx = selection.x + 1;
    var maxy = selection.y + 1;
    var maxz = selection.z + 1;
    return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxz));
};