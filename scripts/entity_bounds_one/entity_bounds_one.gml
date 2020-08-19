/// @param Entity
function entity_bounds_one(argument0) {

    var entity = argument0;

    return [entity.xx, entity.yy, entity.zz, entity.xx + 1, entity.yy + 1, entity.zz + 1];


}
