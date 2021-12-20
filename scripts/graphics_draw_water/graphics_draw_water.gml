function graphics_draw_water(set_lights = true) {
    var map = Stuff.map.active_map;
    if (!map.draw_water) return;
    if (!map.contents.water) return;
    
    matrix_set(matrix_world, matrix_build_identity());
    var tex = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    vertex_submit(map.contents.water, pr_trianglelist, tex);
    
    if (Settings.view.wireframe) {
        wireframe_enable();
        vertex_submit(map.contents.water, pr_trianglelist, -1);
        wireframe_disable();
    }
}