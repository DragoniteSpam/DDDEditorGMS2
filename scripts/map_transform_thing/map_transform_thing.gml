/// @param Entity

var entity = argument0;

if (entity.cobject) {
    c_world_add_object(entity.cobject);
    c_object_set_userid(entity.cobject, entity);
    c_transform_position(entity.xx * TILE_WIDTH, entity.yy * TILE_HEIGHT, entity.zz * TILE_DEPTH);
    c_object_apply_transform(entity.cobject);
    c_transform_identity();
}