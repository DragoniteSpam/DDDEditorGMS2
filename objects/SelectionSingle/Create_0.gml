event_inherited();

z = 0;

// no drag because you can only ever select the cell you click on
onmousedown = function(x, y, z) {
    self.x = x;
    self.y = y;
    self.z = z;
};

area = function() {
    return 1;
};

render = function() {
    var xx = x * TILE_WIDTH;
    var yy = y * TILE_HEIGHT;
    var zz = z * TILE_DEPTH;
    
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

onmove = function(dx, dy, dz) {
    var map = Stuff.map.active_map;
    x = clamp(x + dx, 0, map.xx - 1);
    y = clamp(y + dy, 0, map.yy - 1);
    z = clamp(z + dz, 0, map.zz - 1);
};

foreach_cell = function(processed, script, params) {
    var str = string(x) + "," + string(y) + "," + string(z);
    if (!ds_map_exists(processed, str)) {
        ds_map_add(processed, str, true);
        script(x, y, z, params);
    }
};

selected_determination = function(entity) {
    return (x == entity.xx && y == entity.yy) && (!Stuff.map.active_map.is_3d || z == entity.zz);
};

selected_border_determination = function(entity) {
    var minx = x - 1;
    var miny = y - 1;
    var minz = z - 1;
    var maxx = x + 1;
    var maxy = y + 1;
    var maxz = z + 1;
    return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxz));
};