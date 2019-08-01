if (!mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
    control_animator();
}

d3d_start();
gpu_set_cullmode(view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(true);

// todo GMS2 requires smooth shading to be handled by the shader(s) now,
// so to make porting this to GMS2 as pain-free as possible I'd like to
// do it that way here at some point in the future too

draw_set_color(c_white);

if (ActiveMap.is_3d) {
    d3d_set_projection_ext(anim_x, anim_y, anim_z, anim_xto, anim_yto, anim_zto, anim_xup, anim_yup, anim_zup, anim_fov, CW/CH, 1, 32000);
} else {
    var cwidth = __view_get( e__VW.WView, view_3d );
    var cheight = __view_get( e__VW.HView, view_3d );
    d3d_set_projection_ortho(anim_x - cwidth / 2, anim_y - cheight / 2, cwidth, cheight, 0);
}

// anything in the world

shader_set(shd_default);

shader_reset();

// "set" overwrites the previous transform anyway
transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
vertex_submit(grid_centered, pr_linelist, -1);

transform_reset();