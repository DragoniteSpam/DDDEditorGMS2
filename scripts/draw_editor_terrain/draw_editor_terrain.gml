function draw_editor_terrain() {
    draw_set_color(c_white);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(true);
    
    var camera = view_get_camera(view_current);
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    
    var z2d = CAMERA_ZFAR - 256;
    
    if (orthographic) {
        var view = matrix_build_lookat(x, y, z2d, x, y, 0, 0, 1, 0);
        var proj = matrix_build_projection_ortho(-vw * orthographic_scale, vh * orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
    } else {
        var view = matrix_build_lookat(x, y, z, xto, yto, zto, xup, yup, zup);
        var proj = matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
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
    transform_reset();
    
    if (view_water) {
        graphics_set_lighting_terrain(shd_water);
        graphics_draw_water(false);
    }
    
    // This is officially the worst solution to z fighting ever, but to effectively reset the depth buffer
    // the terrain layer(s) go on their own surface(s).
    if (!surface_exists(depth_surface_base) || surface_get_width(depth_surface_base) != camera_get_view_width(camera) || surface_get_height(depth_surface_base) != camera_get_view_height(camera)) {
        surface_free(depth_surface_base);
        surface_free(depth_surface_top);
        depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
        depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
    }
}