/// @description  void selection_foreach_cell_circle(selection, processed, script, params array);
/// @param selection
/// @param  processed
/// @param  script
/// @param  params array

var minx=max(argument0.x-argument0.radius, 0);
var miny=max(argument0.y-argument0.radius, 0);
var maxx=min(argument0.x+argument0.radius, ActiveMap.xx-1);
var maxy=min(argument0.y+argument0.radius, ActiveMap.yy-1);
// no check for z - this only goes over cells in the layer that the
// that the selection exists on

for (var i=minx; i<maxx; i++){
    for (var j=miny; j<maxy; j++){
        if (point_distance(argument0.x, argument0.y, i+0.5, j+0.5)<argument0.radius){
            var str=string(i)+","+string(j)+","+string(argument0.z);
            if (!ds_map_exists(argument1, str)){
                ds_map_add(argument1, str, true);
                script_execute(argument2, i, j, argument0.z, argument3);
            }
        }
    }
}
