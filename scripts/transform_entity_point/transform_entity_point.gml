/// @param Entity
/// @param x
/// @param y
/// @param z
function transform_entity_point(argument0, argument1, argument2, argument3) {

	var entity = argument0;
	var xx = argument1;
	var yy = argument2;
	var zz = argument3;

	transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
	transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
	var matrix = transform_add(
	    (entity.xx + entity.off_xx) * TILE_WIDTH,
	    (entity.yy + entity.off_yy) * TILE_HEIGHT,
	    (entity.zz + entity.off_zz) * TILE_DEPTH,
	    0, 0, 0, 1, 1, 1
	);

	var result = matrix_transform_vertex(matrix, xx, yy, zz);

	transform_reset();

	return result;


}
