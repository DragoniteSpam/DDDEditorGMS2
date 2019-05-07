/// @description  void selection_foreach_cell_rectangle(selection, processed, script, params array);
/// @param selection
/// @param  processed
/// @param  script
/// @param  params array

var minx=min(argument0.x1, argument0.x2);
var miny=min(argument0.y1, argument0.y2);
var minz=min(argument0.z1, argument0.z2);
var maxx=max(argument0.x1, argument0.x2);
var maxy=max(argument0.y1, argument0.y2);
var maxz=max(argument0.z1, argument0.z2);

for (var i=minx; i<maxx; i++){
    for (var j=miny; j<maxy; j++){
        for (var k=minz; k<maxz; k++){
            var str=string(i)+","+string(j)+","+string(k);
            if (!ds_map_exists(argument1, str)){
                ds_map_add(argument1, str, true);
                script_execute(argument2, i, j, k, argument3);
            }
        }
    }
}
