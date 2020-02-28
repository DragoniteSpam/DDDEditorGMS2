/// @param EntityComponent

var component = argument0;
var mode = Stuff.map;
var camera = camera_get_active();
var map = Stuff.map.active_map;
var map_contents = map.contents;

if (ds_list_find_value(map_contents.active_lights, component.parent.REFID) != -1) {
    var world_x = (component.parent.xx + component.parent.off_xx + 0.5) * TILE_WIDTH;
    var world_y = (component.parent.yy + component.parent.off_yy + 0.5) * TILE_HEIGHT;
    var world_z = (component.parent.zz + component.parent.off_zz + 0.5) * TILE_DEPTH;
    if (selected(component.parent)) {
        var dist = point_distance_3d(mode.x, mode.y, mode.z, world_x, world_y, world_z);
        var f = dist / 160;
        ds_queue_enqueue(Stuff.unlit_meshes, [Stuff.graphics.axes_translation, matrix_build(
            world_x, world_y, world_z, 0, 0, 0, f, f, f
        )]);
    } else {
        ds_queue_enqueue(Stuff.unlit_meshes, [Stuff.graphics.axes_rotation, matrix_build(
            world_x, world_y, world_z, 0, 0, 0,
            component.light_radius / 16, component.light_radius / 16, component.light_radius / 16
        )]);
    }
}