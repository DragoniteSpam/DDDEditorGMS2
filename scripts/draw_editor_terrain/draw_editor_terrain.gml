function draw_editor_terrain() {
    draw_set_color(c_white);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(true);
    
    var camera = view_get_camera(view_current);
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    
    var z2d = CAMERA_ZFAR - 256;
    
    var view = matrix_build_lookat(x, y, z, xto, yto, zto, xup, yup, zup);
    var proj = matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
    
    if (orthographic) {
        view = matrix_build_lookat(x, y, z2d, x, y, 0, 0, 1, 0);
        proj = matrix_build_projection_ortho(-vw * orthographic_scale, vh * orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
    }
    
    camera_set_view_mat(camera, view);
    camera_set_proj_mat(camera, proj);
    camera_apply(camera);
    
    gpu_set_zwriteenable(false);
    gpu_set_ztestenable(false);
    transform_set(x, y, orthographic ? z2d : z, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    
    graphics_set_lighting_terrain(shd_terrain);
    matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, Stuff.terrain.view_scale, Stuff.terrain.view_scale, Stuff.terrain.view_scale));
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "terrainSize"), Stuff.terrain.width, Stuff.terrain.height);
    
    if (!Stuff.terrain.cursor_position) {
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouse"), -MILLION, -MILLION);
    } else {
        shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouse"), Stuff.terrain.cursor_position.x, Stuff.terrain.cursor_position.y);
    }
    texture_set_stage(shader_get_sampler_index(shd_terrain, "texColor"), surface_get_texture(Stuff.terrain.color.surface));
    shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouseRadius"), Stuff.terrain.radius);
    vertex_submit(Stuff.terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(Stuff.terrain.texture, 0));
    
    if (view_water) {
        graphics_set_lighting_terrain(shd_water);
        graphics_draw_water(false);
    }
    
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
}