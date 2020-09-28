/// @param EntityEffect
function render_effect(argument0) {

    var effect = argument0;
    var mode = Stuff.map;
    var camera = camera_get_active();
    var com_offset = 18;

    var world_x = (effect.xx + effect.off_xx) * TILE_WIDTH;
    var world_y = (effect.yy + effect.off_yy) * TILE_HEIGHT;
    var world_z = (effect.zz + effect.off_zz) * TILE_DEPTH;

    var position = world_to_screen(world_x, world_y, world_z, camera_get_view_mat(camera), camera_get_proj_mat(camera), camera_get_view_width(camera), camera_get_view_height(camera));

    if (entity_effect_colliders_active(effect)) {
        var dist = point_distance_3d(mode.x, mode.y, mode.z, world_x, world_y, world_z);
        var f = min(dist / 160, 2.5);
        var transform = matrix_build(world_x, world_y, world_z, 0, 0, 0, f, f, f);
        if (effect.axis_over == CollisionSpecialValues.TRANSLATE_X) {
            graphics_add_gizmo(Stuff.graphics.axes_translation_x_gold, transform, false);
        } else {
            graphics_add_gizmo(Stuff.graphics.axes_translation_x, transform, false);
        }
        if (effect.axis_over == CollisionSpecialValues.TRANSLATE_Y) {
            graphics_add_gizmo(Stuff.graphics.axes_translation_y_gold, transform, false);
        } else {
            graphics_add_gizmo(Stuff.graphics.axes_translation_y, transform, false);
        }
        if (effect.axis_over == CollisionSpecialValues.TRANSLATE_Z) {
            graphics_add_gizmo(Stuff.graphics.axes_translation_z_gold, transform, false);
        } else {
            graphics_add_gizmo(Stuff.graphics.axes_translation_z, transform, false);
        }
    }

    render_effect_add_sprite(spr_star, position, [0, 0]);

    if (effect.com_light) {
        render_effect_add_sprite(effect.com_light.sprite, position, [-com_offset, com_offset]);
        script_execute(effect.com_light.render, effect.com_light);
    }
    if (effect.com_particle) {
        render_effect_add_sprite(effect.com_particle.sprite, position, [0, com_offset]);
        script_execute(effect.com_particle.render, effect.com_particle);
    }
    if (effect.com_audio) {
        render_effect_add_sprite(effect.com_audio.sprite, position, [com_offset, com_offset]);
        script_execute(effect.com_audio.render, effect.com_audio);
    }

    entity_effect_position_colliders(effect);


}
