/// @param x
/// @param y
/// @param z
/// @param params[]

var xx = argument0;
var yy = argument1;
var zz = argument2;
var params = argument3;

var cell = map_get_grid_cell(xx, yy, zz);

if (!cell[@ MapCellContents.EFFECT]) {
    var effect = instance_create_depth(0, 0, 0, EntityEffect);
    map_add_thing(effect, xx, yy, zz);
    entity_effect_position_colliders(effect);
}