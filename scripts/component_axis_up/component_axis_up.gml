/// @param ComponentData

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

for (var i = 0; i < ds_list_size(Stuff.map.selected_entities); i++) {
    var entity = Stuff.map.selected_entities[| i];
    if (instanceof(entity, EntityEffect)) {
        var new_x = clamp(entity.xx + entity.off_xx, 0, map.xx - 1);
        var new_y = clamp(entity.yy + entity.off_yy, 0, map.yy - 1);
        var new_z = clamp(entity.zz + entity.off_zz, 0, map.zz - 1);
        entity.off_xx = frac(new_x);
        entity.off_yy = frac(new_y);
        entity.off_zz = frac(new_z);
        map_move_thing(entity, floor(new_x), floor(new_y), floor(new_z), false);
    }
}