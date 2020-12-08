event_inherited();

x = 0;
y = 0;
z = 0;
x2 = 0;
y2 = 0;
z2 = 0;

onmousedown = function(x, y, z) {
    self.x = x;
    self.y = y;
    self.z = z;
    self.x2 = x;
    self.y2 = y;
    self.z2 = z + 1;
};

onmousedrag = function(x, y) {
    self.x2 = x;
    self.y2 = y;
};

area = function() {
    return (x - x2) * (y - y2);
};

render = function() {
    var minx = min(self.x, self.x2);
    var miny = min(self.y, self.y2);
    var minz = min(self.z, self.z2);
    var maxx = max(self.x, self.x2);
    var maxy = max(self.y, self.y2);
    var maxz = max(self.z, self.z2);
    
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

onmove = function(dx, dy, dz) {
    var map = Stuff.map.active_map;
    
    x = clamp(x + dx, 0, map.xx - 1);
    y = clamp(y + dy, 0, map.yy - 1);
    z = clamp(z + dz, 0, map.zz - 1);
    
    x2 = clamp(x2 + dx, 0, map.xx - 1);
    y2 = clamp(y2 + dy, 0, map.yy - 1);
    z2 = clamp(z2 + dz, 0, map.zz - 1);
    
    var minx = min(x, x2);
    var miny = min(y, y2);
    var minz = min(z, z2);
    var maxx = max(x, x2);
    var maxy = max(y, y2);
    var maxz = max(z, z2);
    
    // we like to avoid having zero-area selections, so try to force it out if that thappens
    x = minx;
    y = miny;
    z = minz;
    x2 = maxx;
    y2 = maxy;
    z2 = maxz;
    
    if (x == x2) {
        x--;
    }
    if (y == y2) {
        y--;
    }
    if (z == z2) {
        z--;
    }
    if (x < 0) {
        x++;
        x2++;
    }
    if (y < 0) {
        y++;
        y2++;
    }
    if (z < 0) {
        z++;
        z2++;
    }
};

foreach_cell = function(processed, script, params) {
    var minx = min(x, x2);
    var miny = min(y, y2);
    var minz = min(z, z2);
    var maxx = max(x, x2);
    var maxy = max(y, y2);
    var maxz = max(z, z2);
    
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

selected_determination = function(entity) {
    var minx = min(x, x2);
    var miny = min(y, y2);
    var minz = min(z, z2);
    var maxx = max(x, x2);
    var maxy = max(y, y2);
    var maxz = max(z, z2);
    
    // exclude the outer edge but don't have a negative area
    var maxex = max(minx, maxx - 1);
    var maxey = max(miny, maxy - 1);
    var maxez = max(minz, maxz - 1);
    
    return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxez));
};

selected_border_determination = function(entity) {
    var minx = min(x, x2) - 1;
    var miny = min(y, y2) - 1;
    var minz = min(z, z2) - 1;
    var maxx = max(x, x2) + 1;
    var maxy = max(y, y2) + 1;
    var maxz = max(z, z2) + 1;
    // exclude the outer edge but don't have a negative area
    var maxex = max(minx, maxx - 1);
    var maxey = max(miny, maxy - 1);
    var maxez = max(minz, maxz - 1);
    return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxez));
};