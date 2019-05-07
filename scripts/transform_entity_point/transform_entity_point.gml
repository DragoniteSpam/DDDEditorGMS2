/// @description  vec3 transform_entity_point(Entity, x, y, z);
/// @param Entity
/// @param  x
/// @param  y
/// @param  z

transform_set(0, 0, 0, argument0.rot_xx, argument0.rot_yy, argument0.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, argument0.scale_xx, argument0.scale_yy, argument0.scale_zz);
transform_add((argument0.xx+argument0.off_xx)*TILE_WIDTH, (argument0.yy+argument0.off_yy)*TILE_HEIGHT, (argument0.zz+argument0.off_zz)*TILE_DEPTH, 0, 0, 0, 1, 1, 1);

var result=d3d_transform_vertex(argument1, argument2, argument3);

transform_reset();

return result;
