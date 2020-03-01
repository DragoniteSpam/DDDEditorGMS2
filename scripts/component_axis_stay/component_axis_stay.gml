/// @param ComponentData
// unlike mouse down and mouse up, this script actually needs to return a value

var component = argument0;
var entity = component.parent;

switch (component.axis) {
    case CollisionSpecialValues.TRANSLATE_X: return vector3(c_hit_x() - Controller.mouse_hit_previous[vec3.xx], 0, 0);
    case CollisionSpecialValues.TRANSLATE_Y: return vector3(0, c_hit_y() - Controller.mouse_hit_previous[vec3.yy], 0);
    case CollisionSpecialValues.TRANSLATE_Z: return vector3(0, 0, c_hit_z() - Controller.mouse_hit_previous[vec3.zz]);
}

return vector3(0, 0, 0);