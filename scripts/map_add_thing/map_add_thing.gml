/// @description  void map_add_thing(Entity, [xx, yy, zz]);
/// @param Entity
/// @param  [xx
/// @param  yy
/// @param  zz]
// Does not check to see if the specified coordinates are in bounds.
// You are responsible for that.

var xx=argument[0].xx;
var yy=argument[0].yy;
var zz=argument[0].zz;

switch (argument_count){
    case 4:
        xx=argument[1];
        yy=argument[2];
        zz=argument[3];
}

var cell=map_get_grid_cell(xx, yy, zz);

// only add thing if the space is not already occupied
if (cell[@ argument[0].slot]==noone){
    cell[@ argument[0].slot]=argument[0];
    
    argument[0].xx=xx;
    argument[0].yy=yy;
    argument[0].zz=zz;
    
    if (argument[0].batchable){
        ds_list_add(ActiveMap.batch_in_the_future, argument[0]);
    } else {
        ds_list_add(ActiveMap.dynamic, argument[0]);
    }
    
    ds_list_add(ActiveMap.all_entities, argument[0]);
    
    map_transform_thing(argument[0]);
    
    argument[0].listed=true;
    
    ds_list_add(Camera.changes, argument[0]);
} else {
    safa_delete(argument[0]);
}
