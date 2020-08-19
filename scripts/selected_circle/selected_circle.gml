/// @param selection
/// @param Entity
function selected_circle(argument0, argument1) {

    var selection = argument0;
    var entity = argument1;

    return (point_distance(selection.x, selection.y, entity.xx + 0.5, entity.yy + 0.5) < selection.radius) && (!Stuff.map.active_map.is_3d || selection.z == entity.zz);


}
