/// @param EntityComponent

var component = argument0;
var mode = Stuff.map;
var camera = camera_get_active();
var map = Stuff.map.active_map;
var map_contents = map.contents;

if (ds_list_find_index(map_contents.active_lights, component.parent.REFID) != -1) {
    var world_x = (component.parent.xx + component.parent.off_xx) * TILE_WIDTH;
    var world_y = (component.parent.yy + component.parent.off_yy) * TILE_HEIGHT;
    var world_z = (component.parent.zz + component.parent.off_zz) * TILE_DEPTH;
    if (!entity_effect_colliders_active(component.parent)) {
        graphics_add_gizmo(Stuff.graphics.axes_rotation, matrix_build(
            world_x, world_y, world_z, 0, 0, 0,
            component.light_radius / 16, component.light_radius / 16, component.light_radius / 16,
        ), true);
    }
}