event_inherited();

z = 0;

// no drag because you can only ever select the cell you click on
onmousedown = sme_down_single;
area = selected_area_single;
render = selection_render_single;

onmove = selection_move_single;

foreach_cell = function(selection, processed, script, params) {
    var str = string(selection.x) + "," + string(selection.y) + "," + string(selection.z);
    if (!ds_map_exists(processed, str)) {
        ds_map_add(processed, str, true);
        script(selection.x, selection.y, selection.z, params);
    }
};

selected_determination = function(selection, entity) {
    var minx = selection.x - 1;
    var miny = selection.y - 1;
    var minz = selection.z - 1;
    var maxx = selection.x + 1;
    var maxy = selection.y + 1;
    var maxz = selection.z + 1;
    return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Stuff.map.active_map.is_3d || is_clamped(entity.zz, minz, maxz));
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