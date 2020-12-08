event_inherited();

z = 0;
radius = 1;

onmousedown = sme_down_circle;
onmousedrag = sme_drag_circle;
area = selected_area_circle;
render = selection_render_circle;

onmove = selection_move_circle;

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