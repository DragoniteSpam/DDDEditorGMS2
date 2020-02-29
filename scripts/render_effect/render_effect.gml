/// @param EntityEffect

var effect = argument0;
var mode = Stuff.map;
var camera = camera_get_active();

var position = world_to_screen(
    (effect.xx + effect.off_xx + 0.5) * TILE_WIDTH, (effect.yy + effect.off_yy + 0.5) * TILE_HEIGHT, (effect.zz + effect.off_zz + 0.5) * TILE_DEPTH,
    camera_get_view_mat(camera), camera_get_proj_mat(camera),
    camera_get_view_width(camera), camera_get_view_height(camera)
);

render_effect_add_sprite(spr_star, position, [0, 0]);

if (effect.com_light) {
    render_effect_add_sprite(effect.com_light.sprite, position, [0, 16]);
    script_execute(effect.com_light.render, effect.com_light);
}
if (effect.com_particle) {
    render_effect_add_sprite(effect.com_particle.sprite, position, [0, 16]);
    script_execute(effect.com_particle.render, effect.com_particle);
}
if (effect.com_audio) {
    render_effect_add_sprite(effect.com_audio.sprite, position, [0, 16]);
    script_execute(effect.com_audio.render, effect.com_audio);
}

if (selected(effect)) {
    if (effect.cobject_x_axis.current_mask == 0) {
        effect.cobject_x_axis.current_mask = CollisionMasks.MAIN;
        effect.cobject_y_axis.current_mask = CollisionMasks.MAIN;
        effect.cobject_z_axis.current_mask = CollisionMasks.MAIN;
        c_object_set_mask(effect.cobject_x_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
        c_object_set_mask(effect.cobject_y_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
        c_object_set_mask(effect.cobject_z_axis.object, CollisionMasks.MAIN, CollisionMasks.MAIN);
        // this means the entity was only just selected - the planes should
        // only be activated when the mouse is down on an axis
    }
} else {
    if (effect.cobject_x_axis.current_mask != 0) {
        effect.cobject_x_axis.current_mask = 0;
        effect.cobject_y_axis.current_mask = 0;
        effect.cobject_z_axis.current_mask = 0;
        effect.cobject_x_plane.current_mask = 0;
        effect.cobject_y_plane.current_mask = 0;
        effect.cobject_z_plane.current_mask = 0;
        c_object_set_mask(effect.cobject_x_axis.object, 0, 0);
        c_object_set_mask(effect.cobject_y_axis.object, 0, 0);
        c_object_set_mask(effect.cobject_z_axis.object, 0, 0);
        c_object_set_mask(effect.cobject_x_plane.object, 0, 0);
        c_object_set_mask(effect.cobject_y_plane.object, 0, 0);
        c_object_set_mask(effect.cobject_z_plane.object, 0, 0);
    }
}

entity_effect_position_colliders(effect);