/// @param EntityEffect
function safc_on_effect(argument0) {

	var effect = argument0;

	safc_on_entity(effect);

	effect.cobject_x_axis.current_mask = CollisionMasks.MAIN;
	effect.cobject_y_axis.current_mask = CollisionMasks.MAIN;
	effect.cobject_z_axis.current_mask = CollisionMasks.MAIN;
	c_object_set_mask(effect.cobject_x_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
	c_object_set_mask(effect.cobject_y_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
	c_object_set_mask(effect.cobject_z_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);


}
