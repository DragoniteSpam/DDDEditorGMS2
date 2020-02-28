/// @param EntityComponent

var component = argument0;
var mode = Stuff.map;
var camera = camera_get_active();

ds_queue_enqueue(Stuff.unlit_meshes, [Stuff.graphics.axes_rotation, matrix_build(
    (component.parent.xx + component.parent.off_xx + 0.5) * TILE_WIDTH,
    (component.parent.yy + component.parent.off_yy + 0.5) * TILE_HEIGHT,
    (component.parent.zz + component.parent.off_zz + 0.5) * TILE_DEPTH,
    0, 0, 0, component.light_radius / 16, component.light_radius / 16, component.light_radius / 16
)]);