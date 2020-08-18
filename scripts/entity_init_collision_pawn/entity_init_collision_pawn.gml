/// @param EntityPawn
function entity_init_collision_pawn(argument0) {

	var pawn = argument0;

	pawn.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);


}
