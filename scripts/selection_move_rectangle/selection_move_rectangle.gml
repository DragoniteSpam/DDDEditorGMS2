/// @param SelectionRectangle
/// @param dx
/// @param dy
/// @param dz
function selection_move_rectangle(argument0, argument1, argument2, argument3) {

    var selection = argument0;
    var dx = argument1;
    var dy = argument2;
    var dz = argument3;
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


}
