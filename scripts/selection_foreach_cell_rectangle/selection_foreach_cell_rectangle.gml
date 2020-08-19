/// @param selection
/// @param processed
/// @param script
/// @param params[]
function selection_foreach_cell_rectangle(argument0, argument1, argument2, argument3) {

    var selection = argument0;
    var processed = argument1;
    var script = argument2;
    var params = argument3;

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
                    script_execute(script, i, j, k, params);
                }
            }
        }
    }


}
