/// @param EntityEffect

var effect = argument0;
var mode = Stuff.map;
var camera = camera_get_active();

ds_queue_enqueue(Stuff.screen_icons, [effect.sprite, world_to_screen(
    (effect.xx + effect.off_xx + 0.5) * TILE_WIDTH, (effect.yy + effect.off_yy + 0.5) * TILE_HEIGHT, (effect.zz + effect.off_zz + 0.5) * TILE_DEPTH,
    camera_get_view_mat(camera), camera_get_proj_mat(camera),
    camera_get_view_width(camera), camera_get_view_height(camera)
)]);