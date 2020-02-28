/// @param EntityEffect

var effect = argument0;
var mode = Stuff.map;
var camera = camera_get_active();

ds_queue_enqueue(Stuff.screen_icons, [effect.sprite, world_to_screen(
    effect.light_x, effect.light_y, effect.light_z,
    camera_get_view_mat(camera), camera_get_proj_mat(camera),
    camera_get_view_width(camera), camera_get_view_height(camera)
)]);