/// @param UIButton
/// @param filename
function terrain_import_heightmap(argument0, argument1) {

    var button = argument0;
    var fn = argument1;
    var image = sprite_add(fn, 0, false, false, 0, 0);
    var terrain = Stuff.terrain;
    var dual = button.root.el_dual_layer.value;
    var scale = string(button.root.el_scale.value);

    terrain.dual_layer = dual;

    terrain.width = sprite_get_width(image);
    terrain.height = sprite_get_height(image);

    var buffer = buffer_create(buffer_sizeof(buffer_u32) * terrain.width * terrain.height, buffer_fixed, 1);
    var surface = surface_create(terrain.width, terrain.height);

    surface_set_target(surface);
    draw_clear_alpha(c_white, 1);
    draw_sprite(image, 0, 0, 0);
    surface_reset_target();

    buffer_get_surface(buffer, surface, 0, 0, 0);

    buffer_delete(terrain.height_data);
    buffer_delete(terrain.color_data);
    buffer_delete(terrain.terrain_buffer_data);
    vertex_delete_buffer(terrain.terrain_buffer);

    terrain.height_data = buffer_create(buffer_sizeof(buffer_f32) * terrain.width * terrain.height, buffer_fixed, 1);
    terrain.color_data = buffer_create(buffer_sizeof(buffer_u32) * terrain.width * terrain.height, buffer_fixed, 1);
    buffer_fill(terrain.color_data, 0, buffer_u32, 0xffffffff, buffer_get_size(terrain.color_data));
    terrain.terrain_buffer = vertex_create_buffer();
    vertex_begin(terrain.terrain_buffer, Stuff.graphics.vertex_format_basic);

    for (var i = 0; i < terrain.width - 1; i++) {
        for (var j = 0; j < terrain.height - 1; j++) {
            terrain_create_square(terrain.terrain_buffer, i, j, 1, 0, 0, terrain.tile_size, terrain.texel);
        }
    }

    vertex_end(terrain.terrain_buffer);
    terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);

    // the first pass is reading out the data
    for (var i = 0; i < terrain.width; i++) {
        for (var j = 0; j < terrain.height; j++) {
            var color = buffer_read(buffer, buffer_u32);
            var rr = color & 0x0000ff;
            var gg = (color & 0x00ff00) >> 8;
            var bb = (color & 0xff0000) >> 16;
            var zz = mean(rr, gg, bb) / scale;
            buffer_write(terrain.height_data, buffer_f32, zz);
            terrain_set_z(terrain, i, j, zz);
        }
    }

    // you need a second pass for normals because the z value of the outer corners could be
    // changed when they're read in
    for (var i = 0; i < terrain.width; i++) {
        for (var j = 0; j < terrain.height; j++) {
            terrain_set_normals(terrain, i, j);
        }
    }

    vertex_freeze(terrain.terrain_buffer);

    terrain_refresh_vertex_buffer(terrain);

    buffer_delete(buffer);
    surface_free(surface);
    sprite_delete(image);


}
