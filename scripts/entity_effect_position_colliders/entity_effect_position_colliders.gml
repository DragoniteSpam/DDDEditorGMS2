/// @param EntityEffect

var effect = argument0;

c_transform_position(effect.xx * TILE_WIDTH, effect.yy * TILE_HEIGHT, effect.zz * TILE_DEPTH);
c_object_apply_transform(effect.cobject_x);
c_object_apply_transform(effect.cobject_y);
c_object_apply_transform(effect.cobject_z);
c_transform_identity();