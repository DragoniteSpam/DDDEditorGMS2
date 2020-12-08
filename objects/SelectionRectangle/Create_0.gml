event_inherited();

x = 0;
y = 0;
z = 0;
x2 = 0;
y2 = 0;
z2 = 0;

onmousedown = function(selection, x, y, z) {
    selection.x = x;
    selection.y = y;
    selection.z = z;
    selection.x2 = x;
    selection.y2 = y;
    selection.z2 = z + 1;
};

onmousedrag = function(selection, x, y) {
    selection.x2 = x;
    selection.y2 = y;
};

area = function(selection) {
    return (selection.x - selection.x2) * (selection.y - selection.y2);
};

render = function(selection) {
    var minx = min(selection.x, selection.x2);
    var miny = min(selection.y, selection.y2);
    var minz = min(selection.z, selection.z2);
    var maxx = max(selection.x, selection.x2);
    var maxy = max(selection.y, selection.y2);
    var maxz = max(selection.z, selection.z2);
    
    var x1 = minx * TILE_WIDTH;
    var y1 = miny * TILE_HEIGHT;
    var z1 = minz * TILE_DEPTH;
    // the outer corner of the cube is already at (32, 32, 32) so we need to
    // compensate for that
    var cube_bound = 32;
    var x2 = maxx * TILE_WIDTH - cube_bound;
    var y2 = maxy * TILE_HEIGHT - cube_bound;
    var z2 = maxz * TILE_DEPTH - cube_bound;
    
    shader_set(shd_bounding_box);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
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
    
    vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
    shader_reset();
};

onmove = function(selection, dx, dy, dz) {
    var map = Stuff.map.active_map;
    
    selection.x = clamp(selection.x + dx, 0, map.xx - 1);
    selection.y = clamp(selection.y + dy, 0, map.yy - 1);
    selection.z = clamp(selection.z + dz, 0, map.zz - 1);
    
    selection.x2 = clamp(selection.x2 + dx, 0, map.xx - 1);
    selection.y2 = clamp(selection.y2 + dy, 0, map.yy - 1);
    selection.z2 = clamp(selection.z2 + dz, 0, map.zz - 1);
    
    var minx = min(selection.x, selection.x2);
    var miny = min(selection.y, selection.y2);
    var minz = min(selection.z, selection.z2);
    var maxx = max(selection.x, selection.x2);
    var maxy = max(selection.y, selection.y2);
    var maxz = max(selection.z, selection.z2);
    
    // we like to avoid having zero-area selections, so try to force it out if that thappens
    selection.x = minx;
    selection.y = miny;
    selection.z = minz;
    selection.x2 = maxx;
    selection.y2 = maxy;
    selection.z2 = maxz;
    
    if (selection.x == selection.x2) {
        selection.x--;
    }
    if (selection.y == selection.y2) {
        selection.y--;
    }
    if (selection.z == selection.z2) {
        selection.z--;
    }
    if (selection.x < 0) {
        selection.x++;
        selection.x2++;
    }
    if (selection.y < 0) {
        selection.y++;
        selection.y2++;
    }
    if (selection.z < 0) {
        selection.z++;
        selection.z2++;
    }
};

foreach_cell = function(selection, processed, script, params) {
    var minx = min(selection.x, selection.x2);
    var miny = min(selection.y, selection.y2);
    var minz = min(selection.z, selection.z2);
    var maxx = max(selection.x, selection.x2);
    var maxy = max(selection.y, selection.y2);
    var maxz = max(selection.z, selection.z2);
    
    for (var i = minx; i < maxx; i++) {
        for (var j = miny; j < maxy; j++) {
            for (var k = minz; k < maxz; k++) {
                var str = string(i) + ","+string(j) + "," + string(k);
                if (!ds_map_exists(processed, str)) {
                    ds_map_add(processed, str, true);
                    script(i, j, k, params);
                }
            }
        }
    }
};

selected_determination = function(selection, entity) {
    var minx = min(selection.x, selection.x2);
    var miny = min(selection.y, selection.y2);
    var minz = min(selection.z, selection.z2);
    var maxx = max(selection.x, selection.x2);
    var maxy = max(selection.y, selection.y2);
    var maxz = max(selection.z, selection.z2);
    
    // exclude the outer edge but don't have a negative area
    var maxex = max(minx, maxx - 1);
    var maxey = max(miny, maxy - 1);
    var maxez = max(minz, maxz - 1);
    
    return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxez));
};
selected_border_determination = function(selection, entity) {
    var minx = min(selection.x, selection.x2) - 1;
    var miny = min(selection.y, selection.y2) - 1;
    var minz = min(selection.z, selection.z2) - 1;
    var maxx = max(selection.x, selection.x2) + 1;
    var maxy = max(selection.y, selection.y2) + 1;
    var maxz = max(selection.z, selection.z2) + 1;
    // exclude the outer edge but don't have a negative area
    var maxex = max(minx, maxx - 1);
    var maxey = max(miny, maxy - 1);
    var maxez = max(minz, maxz - 1);
    return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxez));
};