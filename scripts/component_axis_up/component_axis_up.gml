/// @param ComponentData
function component_axis_up(argument0) {

    var component = argument0;
    var entity = component.parent;
    var map = Stuff.map.active_map;

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

    var effect_list = ds_list_create();

    for (var i = 0; i < ds_list_size(Stuff.map.selected_entities); i++) {
        var ent = Stuff.map.selected_entities[| i];
        if (entity.etype == ETypes.ENTITY_EFFECT) {
            ds_list_add(effect_list, ent);
            var new_x = clamp(ent.xx + ent.off_xx, 0, map.xx - 1);
            var new_y = clamp(ent.yy + ent.off_yy, 0, map.yy - 1);
            var new_z = clamp(ent.zz + ent.off_zz, 0, map.zz - 1);
            ent.off_xx = frac(new_x);
            ent.off_yy = frac(new_y);
            ent.off_zz = frac(new_z);
            Stuff.map.active_map.Move(ent, floor(new_x), floor(new_y), floor(new_z), false);
        }
    }

    selection_clear();

    for (var i = 0; i < ds_list_size(effect_list); i++) {
        var ent = effect_list[| i];
        var selection = new SelectionSingle(ent.xx, ent.yy, ent.zz);
    }

    sa_process_selection();


}
