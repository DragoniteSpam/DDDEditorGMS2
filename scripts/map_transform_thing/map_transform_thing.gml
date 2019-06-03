/// @description void map_transform_thing(Entity);
/// @param Entity

c_world_add_object(argument0.cobject);
c_object_set_userid(argument0.cobject, argument0);
c_transform_position(argument0.xx*TILE_WIDTH, argument0.yy*TILE_HEIGHT, argument0.zz*TILE_DEPTH);
c_object_apply_transform(argument0.cobject);
c_transform_identity();
