/// @param ComponentData
function component_axis_down(argument0) {

    var component = argument0;
    var entity = component.parent;

    switch (component.axis) {
        case CollisionSpecialValues.TRANSLATE_X:
            entity.cobject_x_axis.current_mask = 0;
            entity.cobject_y_axis.current_mask = 0;
            entity.cobject_z_axis.current_mask = 0;
            c_object_set_mask(entity.cobject_x_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_y_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_z_axis.object, 0, 0);
            entity.cobject_x_plane.current_mask = CollisionMasks.AXES;
            c_object_set_mask(entity.cobject_x_plane.object, CollisionMasks.AXES, CollisionMasks.AXES);
            break;
        case CollisionSpecialValues.TRANSLATE_Y:
            entity.cobject_x_axis.current_mask = 0;
            entity.cobject_y_axis.current_mask = 0;
            entity.cobject_z_axis.current_mask = 0;
            c_object_set_mask(entity.cobject_x_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_y_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_z_axis.object, 0, 0);
            entity.cobject_y_plane.current_mask = CollisionMasks.AXES;
            c_object_set_mask(entity.cobject_y_plane.object, CollisionMasks.AXES, CollisionMasks.AXES);
            break;
        case CollisionSpecialValues.TRANSLATE_Z:
            entity.cobject_x_axis.current_mask = 0;
            entity.cobject_y_axis.current_mask = 0;
            entity.cobject_z_axis.current_mask = 0;
            c_object_set_mask(entity.cobject_x_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_y_axis.object, 0, 0);
            c_object_set_mask(entity.cobject_z_axis.object, 0, 0);
            entity.cobject_z_plane.current_mask = CollisionMasks.AXES;
            c_object_set_mask(entity.cobject_z_plane.object, CollisionMasks.AXES, CollisionMasks.AXES);
            break;
    }


}
