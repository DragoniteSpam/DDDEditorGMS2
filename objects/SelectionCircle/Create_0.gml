event_inherited();

z = 0;
radius = 1;

onmousedown = function(selection, x, y, z) {
    selection.x = x;
    selection.y = y;
    selection.z = z;
};

onmousedrag = function(selection, x, y) {
    selection.radius = floor(point_distance(selection.x, selection.y, x, y));
};

area = function(selection) {
    return selection.radius * selection.radius * pi;
};

render = function(selection) {
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
};

onmove = function(selection, dx, dy, dz) {
    var map = Stuff.map.active_map;
    selection.x = clamp(selection.x + dx, 0, map.xx - 1);
    selection.y = clamp(selection.y + dy, 0, map.yy - 1);
    selection.z = clamp(selection.z + dz, 0, map.zz - 1);
};

foreach_cell = function(selection, processed, script, params) {
    var minx = max(selection.x - selection.radius, 0);
    var miny = max(selection.y - selection.radius, 0);
    var maxx = min(selection.x + selection.radius, Stuff.map.active_map.xx - 1);
    var maxy = min(selection.y + selection.radius, Stuff.map.active_map.yy - 1);
    // no check for z - this only goes over cells in the layer that the that the selection exists on
    
    for (var i = minx; i < maxx; i++) {
        for (var j = miny; j < maxy; j++) {
            if (point_distance(selection.x, selection.y, i + 0.5, j + 0.5) < selection.radius) {
                var str = string(i) + "," + string(j) + "," + string(selection.z);
                if (!ds_map_exists(processed, str)) {
                    ds_map_add(processed, str, true);
                    script(i, j, selection.z, params);
                }
            }
        }
    }
}

selected_determination = function(selection, entity) {
    return (point_distance(selection.x, selection.y, entity.xx + 0.5, entity.yy + 0.5) < selection.radius) && (!Stuff.map.active_map.is_3d || selection.z == entity.zz);
};
selected_border_determination = function(selection, entity) {
    var minx = selection.x - 1 - selection.radius;
    var miny = selection.y - 1 - selection.radius;
    var minz = selection.z - 1 - selection.radius;
    var maxx = selection.x + 1 + selection.radius;
    var maxy = selection.y + 1 + selection.radius;
    var maxz = selection.z + 1 + selection.radius;
    return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d && is_clamped(entity.zz, minz, maxz));
};