/// @param filename

var fn = argument0;
var image = sprite_add(fn, 0, false, false, 0, 0);
var terrain = Stuff.terrain;
var dual = thing.root.el_dual_layer.value;

var el_confirm = create_button(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, "Create", b_width, b_height, fa_center, dmu_dialog_commit_terrain_create, dg);

terrain.dual_layer = dual;
Camera.ui_terrain.t_general.element_dual.value = dual;

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
vertex_begin(terrain.terrain_buffer, terrain.vertex_format);

for (var i = 0; i < terrain.width - 1; i++) {
    for (var j = 0; j < terrain.height - 1; j++) {
        terrain_create_square(terrain.terrain_buffer, i, j, 1, 0, 0, terrain.tile_size, terrain.texel);
    }
}

vertex_end(terrain.terrain_buffer);
terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);

for (var i = 0; i < terrain.width; i++) {
    for (var j = 0; j < terrain.width; j++) {
        var zz = (buffer_read(buffer, buffer_u32) & 0x00ffffff) / DEFAULT_TERRAIN_HEIGHTMAP_SCALE;
        buffer_write(terrain.height_data, buffer_f32, zz);
        terrain_set_z(terrain, i, j, zz);
        terrain_set_normals(terrain, i, j);
    }
}

vertex_freeze(terrain.terrain_buffer);

terrain_refresh_vertex_buffer(terrain);

//buffer_delete(buffer);
surface_free(surface);
sprite_delete(image);