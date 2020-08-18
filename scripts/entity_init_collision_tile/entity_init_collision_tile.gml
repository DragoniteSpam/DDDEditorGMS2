/// @param EntityTile
function entity_init_collision_tile(argument0) {

	var tile = argument0;

	tile.cobject = c_object_create_cached(Stuff.graphics.c_shape_tile, CollisionMasks.MAIN, CollisionMasks.MAIN);


}
