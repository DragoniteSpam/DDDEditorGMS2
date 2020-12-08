event_inherited();

x = 0;
y = 0;
z = 0;
x2 = 0;
y2 = 0;
z2 = 0;

onmousedown = sme_down_rectangle;
onmousedrag = sme_drag_rectangle;
area = selected_area_rectangle;
render = selection_render_rectangle;

onmove = selection_move_rectangle;

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