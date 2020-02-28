/// @param EntityEffectPointLight

var effect = argument0;
var mode = Stuff.map;
var camera = camera_get_active();

render_effect(effect);

ds_queue_enqueue(Stuff.unlit_meshes, [Stuff.graphics.axes_rotation, matrix_build(
    effect.light_x, effect.light_y, effect.light_z,
    0, 0, 0, effect.light_radius / 16, effect.light_radius / 16, effect.light_radius / 16
)]);