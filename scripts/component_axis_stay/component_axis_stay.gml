/// @param ComponentData
function component_axis_stay(argument0) {

    var component = argument0;
    var entity = component.parent;

    switch (component.axis) {
        case CollisionSpecialValues.TRANSLATE_X: var delta = [(c_hit_x() - Controller.mouse_hit_previous[vec3.xx]) / TILE_WIDTH, 0, 0]; break;
        case CollisionSpecialValues.TRANSLATE_Y: var delta = [0, (c_hit_y() - Controller.mouse_hit_previous[vec3.yy]) / TILE_HEIGHT, 0]; break;
        case CollisionSpecialValues.TRANSLATE_Z: var delta = [0, 0, (c_hit_z() - Controller.mouse_hit_previous[vec3.zz]) / TILE_DEPTH]; break;
        default: var delta = [0, 0, 0]; break;
    }

    for (var i = 0; i < ds_list_size(Stuff.map.selected_entities); i++) {
        var entity = Stuff.map.selected_entities[| i];
        if (instanceof_classic(entity, EntityEffect)) {
            entity.off_xx += delta[vec3.xx];
            entity.off_yy += delta[vec3.yy];
            entity.off_zz += delta[vec3.zz];
        }
    }

    Controller.mouse_hit_previous = [c_hit_x(), c_hit_y(), c_hit_z()];


}
