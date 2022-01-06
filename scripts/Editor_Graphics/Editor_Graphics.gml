function EditorGraphics() constructor {
    static Init = function() {
        gpu_set_alphatestenable(true);
        gpu_set_alphatestref(20);
        gpu_set_tex_repeat(true);
        
        vertex_format_begin();
        self.format_size = 0;
        vertex_format_add_position_3d();
        self.format_size += 12;
        vertex_format_add_normal();
        self.format_size += 12;
        vertex_format_add_texcoord();
        self.format_size += 8;
        vertex_format_add_colour();
        self.format_size += 4;
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // tangent vectors
        self.format_size += 12;
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // bitangent vectors
        self.format_size += 12;
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // barycentric coordinates
        self.format_size += 12;                                                 // should be 72
        self.vertex_format = vertex_format_end();
        
        meshop_init(self.format_size);
        show_debug_message("MeshOps version: " + string(meshop_version()));
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_colour();
        self.vertex_format_wireframe = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        self.vertex_format_axes = vertex_format_end();
        
        #region basic grids
        self.grid_centered = vertex_load("data/basic/grid_centered.vbuff", self.vertex_format_wireframe);
        self.wire_box = vertex_load("data/basic/wire_box.vbuff", self.vertex_format_wireframe);
        self.wire_sphere = vertex_load("data/basic/wire_sphere.vbuff", self.vertex_format_wireframe);
        self.wire_capsule = vertex_load("data/basic/wire_capsule.vbuff", self.vertex_format_wireframe);
        self.grid_sphere = vertex_load("data/basic/icosphere.vbuff", self.vertex_format_wireframe);
        self.axes = vertex_load("data/basic/axes_corner.vbuff", self.vertex_format_axes);
        self.axes_center = vertex_load("data/basic/axes_center.vbuff", self.vertex_format_axes);
        #endregion
        
        self.basic_cage = import_d3d("data/basic/cage.d3d", false);
        self.indexed_cage = import_d3d("data/basic/cage-indexed.d3d", false);
        self.indexed_cage_full = import_d3d("data/basic/cage-indexed-full.d3d", false);
        self.basic_cube = import_d3d("data/basic/cube.d3d", false);
        // load both buffers
        var missing = import_d3d("data/basic/missing_autotile.d3d", false, true);
        self.missing_autotile = missing[0];
        self.missing_autotile_raw = missing[1];
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
        
        self.grid = undefined;
        self.default_skybox = sprite_add(PATH_GRAPHICS + "b_sky_clouds_blue.png", 0, false, false, 0, 0);
    };
    
    static RecreateGrids = function() {
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        if (self.grid) vertex_delete_buffer(self.grid);
        self.grid = vertex_create_buffer();
        vertex_begin(self.grid, self.vertex_format_wireframe);
        
        for (var i = 0; i <= map.xx; i++) {
            var xx = i * TILE_WIDTH;
            var yy = map.yy * TILE_HEIGHT;
            vertex_position_3d(self.grid, xx, 0, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_colour(self.grid, c_white, 1);
            vertex_position_3d(self.grid, xx, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_colour(self.grid, c_white, 1);
        }
        
        for (var i = 0; i <= map.yy; i++) {
            var xx = map.xx * TILE_HEIGHT;
            var yy = i * TILE_WIDTH;
            vertex_position_3d(self.grid, 0, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_colour(self.grid, c_white, 1);
            vertex_position_3d(self.grid, xx, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_colour(self.grid, c_white, 1);
        }
        
        vertex_end(self.grid);
        vertex_freeze(self.grid);
    };
}