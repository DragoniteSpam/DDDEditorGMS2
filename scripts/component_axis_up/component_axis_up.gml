/// @param ComponentData

var component = argument0;
var entity = component.parent;

entity.cobject_x_axis.current_mask = CollisionMasks.MAIN;
entity.cobject_y_axis.current_mask = CollisionMasks.MAIN;
entity.cobject_z_axis.current_mask = CollisionMasks.MAIN;
c_object_set_mask(entity.cobject_x_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
c_object_set_mask(entity.cobject_y_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
c_object_set_mask(entity.cobject_z_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
entity.cobject_x_plane.current_mask = 0;
entity.cobject_y_plane.current_mask = 0;
entity.cobject_z_plane.current_mask = 0;
c_object_set_mask(entity.cobject_x_plane.object, 0, 0);
c_object_set_mask(entity.cobject_y_plane.object, 0, 0);
c_object_set_mask(entity.cobject_z_plane.object, 0, 0);