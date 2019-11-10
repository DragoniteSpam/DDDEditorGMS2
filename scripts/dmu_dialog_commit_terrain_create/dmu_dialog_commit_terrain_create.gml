/// @param UIButton

var button = argument0;
var terrain = Stuff.terrain;

var width = real(button.root.el_width.value);
var height = real(button.root.el_height.value);
var dual = button.root.el_dual_layer.value;

terrain.width = width;
Stuff.terrain.ui.t_general.element_width.text = "Width: " + string(width);
terrain.height = height;
Stuff.terrain.ui.t_general.element_height.text = "Height: " + string(height);

buffer_delete(terrain.height_data);
buffer_delete(terrain.color_data);
buffer_delete(terrain.terrain_buffer_data);
vertex_delete_buffer(terrain.terrain_buffer);

terrain.height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
terrain.color_data = buffer_create(buffer_sizeof(buffer_u32) * width * height, buffer_fixed, 1);
buffer_fill(terrain.color_data, 0, buffer_u32, 0xffffffff, buffer_get_size(terrain.color_data));

terrain.terrain_buffer = vertex_create_buffer();
vertex_begin(terrain.terrain_buffer, Stuff.graphics.vertex_format_basic);

for (var i = 0; i < width - 1; i++) {
    for (var j = 0; j < height - 1; j++) {
        terrain_create_square(terrain.terrain_buffer, i, j, 1, 0, 0, terrain.tile_size, terrain.texel);
    }
}

vertex_end(terrain.terrain_buffer);

terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);

vertex_freeze(terrain.terrain_buffer);

script_execute(button.root.commit, button.root);