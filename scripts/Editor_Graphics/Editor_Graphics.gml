function EditorGraphics() constructor {
    static Init = function() {
        gpu_set_alphatestenable(true);
        gpu_set_alphatestref(20);
        gpu_set_tex_repeat(true);
        
        vertex_format_begin();
        self.format_size = 0;
        vertex_format_add_position_3d();
        self.format_size = self.format_size + 12;
        vertex_format_add_normal();
        self.format_size = self.format_size + 12;
        vertex_format_add_texcoord();
        self.format_size = self.format_size + 8;
        vertex_format_add_colour();
        self.format_size = self.format_size + 4;
        self.vertex_format = vertex_format_end();
        
        self.mesh_preview_grid = vertex_create_buffer();
        vertex_begin(self.mesh_preview_grid, self.vertex_format);
        
        var s2 = 6;
        var x1 = -s2 * TILE_WIDTH;
        var y1 = -s2 * TILE_HEIGHT;
        var x2 = -x1;
        var y2 = -y1;
        
        for (var i = 0; i <= 12; i++) {
            vertex_point_line(self.mesh_preview_grid, x1 + i * TILE_WIDTH, y1, 0, c_white, 1);
            vertex_point_line(self.mesh_preview_grid, x1 + i * TILE_WIDTH, y2, 0, c_white, 1);
            vertex_point_line(self.mesh_preview_grid, x1, y1 + i * TILE_HEIGHT, 0, c_white, 1);
            vertex_point_line(self.mesh_preview_grid, x2, y1 + i * TILE_HEIGHT, 0, c_white, 1);
        }
        
        vertex_end(self.mesh_preview_grid);
        vertex_freeze(self.mesh_preview_grid);
        
        c_transform_scaling(Stuff.tile_width, Stuff.tile_height, Stuff.tile_depth);
        self.c_shape_tile = c_shape_create();
        c_transform_position(0.5, 0.5, 0);
        c_shape_add_box(self.c_shape_tile, 0.5, 0.5, 0);
        c_transform_identity();
        self.c_shape_block = c_shape_create();
        c_transform_position(0.5, 0.5, 0.5);
        c_shape_add_box(self.c_shape_block, 0.5, 0.5, 0.5);
        c_transform_identity();
        self.c_shape_sphere = c_shape_create();
        c_shape_add_sphere(self.c_shape_sphere, 1);
        
        var thin_length = 8;
        var long_length = 108;
        self.c_shape_axis_x = c_shape_create();
        self.c_shape_axis_y = c_shape_create();
        self.c_shape_axis_z = c_shape_create();
        self.c_shape_axis_x_plane = c_shape_create();
        self.c_shape_axis_y_plane = c_shape_create();
        self.c_shape_axis_z_plane = c_shape_create();
        c_shape_add_box(self.c_shape_axis_x, long_length, thin_length, thin_length);
        c_shape_add_box(self.c_shape_axis_y, thin_length, long_length, thin_length);
        c_shape_add_box(self.c_shape_axis_z, thin_length, thin_length, long_length);
        c_shape_add_plane(self.c_shape_axis_x_plane, 0, 1, 0, 0);
        c_shape_add_plane(self.c_shape_axis_x_plane, 0, 0, 1, 0);
        c_shape_add_plane(self.c_shape_axis_y_plane, 1, 0, 0, 0);
        c_shape_add_plane(self.c_shape_axis_y_plane, 0, 0, 1, 0);
        c_shape_add_plane(self.c_shape_axis_z_plane, 1, 0, 0, 0);
        c_shape_add_plane(self.c_shape_axis_z_plane, 0, 0, 1, 0);
        
        self.basic_cage = import_d3d("data/basic/cage.d3d", false);
        self.indexed_cage = import_d3d("data/basic/cage-indexed.d3d", false);
        self.indexed_cage_full = import_d3d("data/basic/cage-indexed-full.d3d", false);
        self.basic_cube = import_d3d("data/basic/cube.d3d", false);
        // load both buffers
        var missing = import_d3d("data/basic/missing_autotile.d3d", false, true);
        self.missing_autotile = missing[0];
        self.missing_autotile_raw = missing[1];
        self.missing_autotile_wire = vertex_buffer_to_wireframe(self.missing_autotile);
        self.indexed_cube = import_d3d("data/basic/cube-indexed.d3d", false);
        self.base_npc = import_d3d("data/basic/base-npc.d3d", false);
        self.axes_rotation = import_d3d("data/basic/rotation.d3d", false);
        self.axes_translation = import_d3d("data/basic/translation.d3d", false);
        self.axes_translation_x = import_d3d("data/basic/translation-x.d3d", false);
        self.axes_translation_y = import_d3d("data/basic/translation-y.d3d", false);
        self.axes_translation_z = import_d3d("data/basic/translation-z.d3d", false);
        self.axes_translation_x_gold = import_d3d("data/basic/translation-x-gold.d3d", false);
        self.axes_translation_y_gold = import_d3d("data/basic/translation-y-gold.d3d", false);
        self.axes_translation_z_gold = import_d3d("data/basic/translation-z-gold.d3d", false);
        self.skybox_base = import_d3d("data/basic/skybox-base.d3d", false);
        var qmark_data = import_d3d("data/basic/missing.d3d", false, true);
        self.mesh_missing = qmark_data[0];
        self.mesh_missing_data = qmark_data[1];
        
        self.centered_sphere = import_d3d("data/basic/centered-sphere.d3d", false, false);
        self.centered_cube = import_d3d("data/basic/centered-cube.d3d", false, false);
        self.centered_capsule = import_d3d("data/basic/centered-capsule.d3d", false, false);
        
        self.water_tile_size = 0x1000;
        self.water_reptition = 80;
        self.water_units = 80;
        self.water_depth = -1;
        
        self.mesh_water_base = vertex_create_buffer();
        self.mesh_water_bright = vertex_create_buffer();
        
        vertex_begin(self.mesh_water_base, self.vertex_format);
        vertex_begin(self.mesh_water_bright, self.vertex_format);
        
        for (var i = -self.water_tile_size / 2; i < self.water_tile_size / 2; i += (self.water_tile_size / self.water_units)) {
            for (var j = -self.water_tile_size / 2; j < self.water_tile_size / 2; j += (self.water_tile_size / self.water_units)) {
                vertex_square(self.mesh_water_base, i, j, self.water_tile_size / self.water_units, 0, 0, self.water_reptition / self.water_units, self.water_depth, self.water_depth, self.water_depth, self.water_depth);
                vertex_square(self.mesh_water_bright, i, j, self.water_tile_size / self.water_units, 0, 0, self.water_reptition / self.water_units, self.water_depth, self.water_depth, self.water_depth, self.water_depth);
            }
        }
        
        vertex_end(self.mesh_water_base);
        vertex_end(self.mesh_water_bright);
        vertex_freeze(self.mesh_water_base);
        vertex_freeze(self.mesh_water_bright);
        
        self.grid_sphere = vertex_create_buffer();
        vertex_begin(self.grid_sphere, self.vertex_format);
        
        var radius = 16;
        var segments = 16;
        
        for (var i = 0; i < segments; i++) {
            var angle = i * 360 / segments;
            var angle_next = (i + 1) * 360 / segments;
            for (var j = 0; j < segments / 2; j++) {
                var arc = j * 2 * 180 / segments - 90;
                var arc2 = (j + 1) * 2 * 180 / segments - 90;
                var point = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle, radius, radius, radius), dcos(arc), 0, dsin(arc));
                var point2 = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle, radius, radius, radius), dcos(arc2), 0, dsin(arc2));
                
                var point_next = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle_next, radius, radius, radius), dcos(arc), 0, dsin(arc));
                var point2_next = matrix_transform_vertex(matrix_build(0, 0, 0, 0, 0, angle_next, radius, radius, radius), dcos(arc2), 0, dsin(arc2));
                
                vertex_point_line(self.grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point[vec3.xx], point[vec3.yy], point[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point2_next[vec3.xx], point2_next[vec3.yy], point2_next[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point2[vec3.xx], point2[vec3.yy], point2[vec3.zz], c_magenta, 1);
                vertex_point_line(self.grid_sphere, point_next[vec3.xx], point_next[vec3.yy], point_next[vec3.zz], c_magenta, 1);
            }
        }
        
        vertex_end(self.grid_sphere);
        vertex_freeze(self.grid_sphere);
        
        self.axes = vertex_create_buffer();
        vertex_begin(self.axes, self.vertex_format);
        
        vertex_point_line(self.axes, 0, 0, 0, c_red, 1);
        vertex_point_line(self.axes, MILLION, 0, 0, c_red, 1);
        
        vertex_point_line(self.axes, 0, 0, 0, c_green, 1);
        vertex_point_line(self.axes, 0, MILLION, 0, c_green, 1);
        
        vertex_point_line(self.axes, 0, 0, 0, c_blue, 1);
        vertex_point_line(self.axes, 0, 0, MILLION, c_blue, 1);
        
        vertex_end(self.axes);
        vertex_freeze(self.axes);
        
        self.axes_width = vertex_create_buffer();
        vertex_begin(self.axes_width, self.vertex_format);
        
        vertex_point_line(self.axes_width, 0, -1, -1, c_red, 1);
        vertex_point_line(self.axes_width, MILLION, -1, -1, c_red, 1);
        vertex_point_line(self.axes_width, 0, -1, 1, c_red, 1);
        vertex_point_line(self.axes_width, MILLION, -1, 1, c_red, 1);
        vertex_point_line(self.axes_width, 0, 1, -1, c_red, 1);
        vertex_point_line(self.axes_width, MILLION, 1, -1, c_red, 1);
        vertex_point_line(self.axes_width, 0, 1, 1, c_red, 1);
        vertex_point_line(self.axes_width, MILLION, 1, 1, c_red, 1);
        
        vertex_point_line(self.axes_width, -1, 0, -1, c_green, 1);
        vertex_point_line(self.axes_width, -1, MILLION, -1, c_green, 1);
        vertex_point_line(self.axes_width, -1, 0, 1, c_green, 1);
        vertex_point_line(self.axes_width, -1, MILLION, 1, c_green, 1);
        vertex_point_line(self.axes_width, 1, 0, -1, c_green, 1);
        vertex_point_line(self.axes_width, 1, MILLION, -1, c_green, 1);
        vertex_point_line(self.axes_width, 1, 0, 1, c_green, 1);
        vertex_point_line(self.axes_width, 1, MILLION, 1, c_green, 1);
        
        vertex_point_line(self.axes_width, -1, -1, 0, c_blue, 1);
        vertex_point_line(self.axes_width, -1, -1, MILLION, c_blue, 1);
        vertex_point_line(self.axes_width, -1, 1, 0, c_blue, 1);
        vertex_point_line(self.axes_width, -1, 1, MILLION, c_blue, 1);
        vertex_point_line(self.axes_width, 1, -1, 0, c_blue, 1);
        vertex_point_line(self.axes_width, 1, -1, MILLION, c_blue, 1);
        vertex_point_line(self.axes_width, 1, 1, 0, c_blue, 1);
        vertex_point_line(self.axes_width, 1, 1, MILLION, c_blue, 1);
        
        vertex_end(self.axes_width);
        vertex_freeze(self.axes_width);
        
        self.axes_centered = vertex_create_buffer();
        vertex_begin(self.axes_centered, self.vertex_format);
        
        vertex_point_line(self.axes_centered, -MILLION, 0, 0, c_red, 1);
        vertex_point_line(self.axes_centered, MILLION, 0, 0, c_red, 1);
        
        vertex_point_line(self.axes_centered, 0, -MILLION, 0, c_green, 1);
        vertex_point_line(self.axes_centered, 0, MILLION, 0, c_green, 1);
        
        vertex_point_line(self.axes_centered, 0, 0, -MILLION, c_blue, 1);
        vertex_point_line(self.axes_centered, 0, 0, MILLION, c_blue, 1);
            
        vertex_end(self.axes_centered);
        vertex_freeze(self.axes_centered);
        
        self.grid = undefined;
        self.grid_centered = undefined;
        self.default_skybox = sprite_add(PATH_GRAPHICS + "b_sky_clouds_blue.png", 0, false, false, 0, 0);
        
        self.wire_box = vertex_create_buffer();
        vertex_begin(self.wire_box, self.vertex_format);
        var s = 0.5;
        // bottom
        vertex_point_line(self.wire_box, -s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box, -s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s, -s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s, -s, c_lime, 1);
        // top
        vertex_point_line(self.wire_box, -s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box, -s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s,  s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s,  s, c_lime, 1);
        // pillars
        vertex_point_line(self.wire_box, -s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box, -s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s, -s,  s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s, -s, c_lime, 1);
        vertex_point_line(self.wire_box, -s,  s,  s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s, -s, c_lime, 1);
        vertex_point_line(self.wire_box,  s,  s,  s, c_lime, 1);
        vertex_end(self.wire_box);
        
        self.wire_sphere = vertex_create_buffer();
        vertex_begin(self.wire_sphere, self.vertex_format);
        var r = 0.5;
        for (var i = 0; i < 360; i += 15) {
            vertex_point_line(self.wire_sphere, 0, r * dcos(i     ), -r * dsin(i     ), c_lime, 1);
            vertex_point_line(self.wire_sphere, 0, r * dcos(i + 15), -r * dsin(i + 15), c_lime, 1);
            vertex_point_line(self.wire_sphere, r * dcos(i     ), 0, -r * dsin(i     ), c_lime, 1);
            vertex_point_line(self.wire_sphere, r * dcos(i + 15), 0, -r * dsin(i + 15), c_lime, 1);
            vertex_point_line(self.wire_sphere, r * dcos(i     ), -r * dsin(i     ), 0, c_lime, 1);
            vertex_point_line(self.wire_sphere, r * dcos(i + 15), -r * dsin(i + 15), 0, c_lime, 1);
        }
        vertex_end(self.wire_sphere);
        
        self.wire_capsule = vertex_create_buffer();
        vertex_begin(self.wire_capsule, self.vertex_format);
        r = 0.5;
        var l = 0.5;
        for (var i = 0; i < 180; i += 15) {
            // bottom
            vertex_point_line(self.wire_capsule, 0, r * dcos(i     ), -r * dsin(i     ) - l, c_lime, 1);
            vertex_point_line(self.wire_capsule, 0, r * dcos(i + 15), -r * dsin(i + 15) - l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i     ), 0, -r * dsin(i     ) - l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i + 15), 0, -r * dsin(i + 15) - l, c_lime, 1);
            // top
            vertex_point_line(self.wire_capsule, 0, r * dcos(i     ),  r * dsin(i     ) + l, c_lime, 1);
            vertex_point_line(self.wire_capsule, 0, r * dcos(i + 15),  r * dsin(i + 15) + l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i     ), 0,  r * dsin(i     ) + l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i + 15), 0,  r * dsin(i + 15) + l, c_lime, 1);
        }
        for (var i = 0; i < 360; i += 15) {
            vertex_point_line(self.wire_capsule, r * dcos(i     ), -r * dsin(i     ), -l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i + 15), -r * dsin(i + 15), -l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i     ), -r * dsin(i     ), +l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i + 15), -r * dsin(i + 15), +l, c_lime, 1);
        }
        for (var i = 0; i < 360; i += 90) {
            vertex_point_line(self.wire_capsule, r * dcos(i     ), -r * dsin(i     ), -l, c_lime, 1);
            vertex_point_line(self.wire_capsule, r * dcos(i     ), -r * dsin(i     ), +l, c_lime, 1);
        }
        vertex_end(self.wire_capsule);
    };
}