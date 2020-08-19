/// @param selection
/// @param Entity
function selected_border_rectangle(argument0, argument1) {

    var selection = argument0;
    var entity = argument1;

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


}
