/// @param EntityEffectLight

var light = argument0;

if (light.cobject) {
    c_world_add_object(light.cobject);
    c_object_set_userid(light.cobject, light);
    c_transform_scaling(light.light_radius, light.light_radius, light.light_radius);
    c_transform_position(light.light_x, light.light_y, light.light_z);
    c_object_apply_transform(light.cobject);
    c_transform_identity();
}