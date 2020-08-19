/// @param EntityEffect
function entity_effect_colliders_active(argument0) {

    var effect = argument0;

    return effect.cobject_x_axis.current_mask || effect.cobject_x_plane.current_mask || effect.cobject_y_plane.current_mask || effect.cobject_z_plane.current_mask;


}
