event_inherited();

z = 0;
radius = 1;

onmousedown = function(x, y, z) {
    self.x = x;
    self.y = y;
    self.z = z;
};

onmousedrag = function(x, y) {
    radius = floor(point_distance(x, y, x, y));
};

area = function() {
    return radius * radius * pi;
};

render = function() {
    transform_set(0, 0, z * TILE_DEPTH + 1, 0, 0, 0, 1, 1, 1);
    
    var precision = 24;
    var step = 360 / precision;
    var cx = x * TILE_WIDTH;
    var cy = y * TILE_HEIGHT;
    var cz = z * TILE_DEPTH;
    var rw = radius * TILE_WIDTH;
    var rh = radius * TILE_HEIGHT;
    var rd = radius * TILE_DEPTH;
    var w = 12;
    
    for (var i = 0; i < precision; i++) {
        var angle = i * step;
        var angle2 = (i + 1) * step;
        draw_line_width_colour(cx + rw * dcos(angle), cy - rh * dsin(angle), cx + rw * dcos(angle2), cy - rh * dsin(angle2), w, c_red, c_red);
    }
    
    transform_reset();
};

onmove = function(dx, dy, dz) {
    var map = Stuff.map.active_map;
    x = clamp(x + dx, 0, map.xx - 1);
    y = clamp(y + dy, 0, map.yy - 1);
    z = clamp(z + dz, 0, map.zz - 1);
};

foreach_cell = function(processed, script, params) {
    var minx = max(x - radius, 0);
    var miny = max(y - radius, 0);
    var maxx = min(x + radius, Stuff.map.active_map.xx - 1);
    var maxy = min(y + radius, Stuff.map.active_map.yy - 1);
    // no check for z - this only goes over cells in the layer that the that the selection exists on
    
    for (var i = minx; i < maxx; i++) {
        for (var j = miny; j < maxy; j++) {
            if (point_distance(x, y, i + 0.5, j + 0.5) < radius) {
                var str = string(i) + "," + string(j) + "," + string(z);
                if (!variable_struct_exists(processed, str)) {
                    processed[$ str] = true;
                    script(i, j, z, params);
                }
            }
        }
    }
}

selected_determination = function(entity) {
    return (point_distance(x, y, entity.xx + 0.5, entity.yy + 0.5) < radius) && (!Stuff.map.active_map.is_3d || z == entity.zz);
};

selected_border_determination = function(entity) {
    var minx = x - 1 - radius;
    var miny = y - 1 - radius;
    var minz = z - 1 - radius;
    var maxx = x + 1 + radius;
    var maxy = y + 1 + radius;
    var maxz = z + 1 + radius;
    return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d && is_clamped(entity.zz, minz, maxz));
};