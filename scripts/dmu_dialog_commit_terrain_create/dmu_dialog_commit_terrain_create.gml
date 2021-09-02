function dmu_dialog_commit_terrain_create() {
    var terrain = Stuff.terrain;
    
    var width = real(self.root.el_width.value);
    var height = real(self.root.el_height.value);
    var dual = self.root.el_dual_layer.value;
    
    terrain.width = width;
    Stuff.terrain.ui.t_general.element_width.text = "Width: " + string(width);
    terrain.height = height;
    Stuff.terrain.ui.t_general.element_height.text = "Height: " + string(height);
    
    buffer_delete(terrain.height_data);
    buffer_delete(terrain.terrain_buffer_data);
    vertex_delete_buffer(terrain.terrain_buffer);
    
    terrain.color.Reset(width, height);
    var scale = 1;
    
    if (self.root.el_noise.value) {
        var ww = power(2, ceil(log2(width)));
        var hh = power(2, ceil(log2(height)));
        terrain.height_data = macaw_generate_dll(ww, hh, self.root.el_octaves.value).noise;
        scale = real(self.root.el_scale.value);
    } else {
        terrain.height_data = buffer_create(buffer_sizeof(buffer_f32) * width * height, buffer_fixed, 1);
    }
    
    terrain.terrain_buffer = vertex_create_buffer();
    vertex_begin(terrain.terrain_buffer, terrain.vertex_format);
    
    for (var i = 0; i < width - 1; i++) {
        for (var j = 0; j < height - 1; j++) {
            var z00 = buffer_peek(terrain.height_data, (((i + 0) * height) + (j + 0)) * 4, buffer_f32) * scale;
            var z01 = buffer_peek(terrain.height_data, (((i + 0) * height) + (j + 1)) * 4, buffer_f32) * scale;
            var z10 = buffer_peek(terrain.height_data, (((i + 1) * height) + (j + 0)) * 4, buffer_f32) * scale;
            var z11 = buffer_peek(terrain.height_data, (((i + 1) * height) + (j + 1)) * 4, buffer_f32) * scale;
            terrain_create_square(terrain.terrain_buffer, i, j, z00, z10, z11, z01);
        }
    }
    
    vertex_end(terrain.terrain_buffer);
    terrain.terrain_buffer_data = buffer_create_from_vertex_buffer(terrain.terrain_buffer, buffer_fixed, 1);
    vertex_freeze(terrain.terrain_buffer);
    
    self.root.Dispose();
}