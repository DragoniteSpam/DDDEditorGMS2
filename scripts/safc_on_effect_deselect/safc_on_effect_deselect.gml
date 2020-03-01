/// @param EntityEffect

var effect = argument0;

safc_on_entity_deselect(effect);

effect.cobject_x_axis.current_mask = 0;
effect.cobject_y_axis.current_mask = 0;
effect.cobject_z_axis.current_mask = 0;
c_object_set_mask(effect.cobject_x_axis.object, 0, 0);
c_object_set_mask(effect.cobject_y_axis.object, 0, 0);
c_object_set_mask(effect.cobject_z_axis.object, 0, 0);