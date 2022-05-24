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
        self.format = vertex_format_end();
        
        meshops_init(self.format_size);
        show_debug_message("MeshOps version: " + string(meshops_version()));
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_colour();
        self.format_pnc = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        self.format_ptc = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        self.format_pntc = vertex_format_end();
        
        #region basic grids
        self.grid_centered = vertex_load("data/basic/grid_centered.vbuff", self.format_ptc);
        self.wire_box = vertex_load("data/basic/wire_box.vbuff", self.format_ptc);
        self.wire_sphere = vertex_load("data/basic/wire_sphere.vbuff", self.format_ptc);
        self.wire_capsule = vertex_load("data/basic/wire_capsule.vbuff", self.format_ptc);
        self.grid_sphere = vertex_load("data/basic/icosphere.vbuff", self.format_ptc);
        self.axes = vertex_load("data/basic/axes_corner.vbuff", self.format_ptc);
        self.axes_center = vertex_load("data/basic/axes_center.vbuff", self.format_ptc);
        #endregion
        
        self.basic_cage = vertex_load("data/basic/cage.vbuff", self.format_pntc);
        self.indexed_cage = vertex_load("data/basic/cage-indexed.vbuff", self.format_pntc);
        self.indexed_cage_full = vertex_load("data/basic/cage-indexed-full.vbuff", self.format_pntc);
        self.basic_cube = vertex_load("data/basic/cube.vbuff", self.format_pntc);
        // load both buffers
        var missing_data = buffer_load("data/basic/missing_autotile.vbuff");
        self.missing_autotile = vertex_create_buffer_from_buffer(missing_data, self.format_pntc);
        vertex_freeze(self.missing_autotile);
        self.missing_autotile_raw = missing_data;
        self.indexed_cube = vertex_load("data/basic/cube-indexed.vbuff", self.format_pntc);
        self.base_npc = vertex_load("data/basic/base-npc.vbuff", self.format_pntc);
        self.axes_rotation = vertex_load("data/basic/rotation.vbuff", self.format_pntc);
        self.axes_translation = vertex_load("data/basic/translation.vbuff", self.format_pntc);
        self.axes_translation_x = vertex_load("data/basic/translation-x.vbuff", self.format_pntc);
        self.axes_translation_y = vertex_load("data/basic/translation-y.vbuff", self.format_pntc);
        self.axes_translation_z = vertex_load("data/basic/translation-z.vbuff", self.format_pntc);
        self.axes_translation_x_gold = vertex_load("data/basic/translation-x-gold.vbuff", self.format_pntc);
        self.axes_translation_y_gold = vertex_load("data/basic/translation-y-gold.vbuff", self.format_pntc);
        self.axes_translation_z_gold = vertex_load("data/basic/translation-z-gold.vbuff", self.format_pntc);
        self.skybox_base = vertex_load("data/basic/skybox-base.vbuff", self.format_pntc);
        var qmark_data = buffer_load("data/basic/missing.vbuff");
        self.mesh_missing = vertex_create_buffer_from_buffer(qmark_data, self.format_pntc);
        vertex_freeze(self.mesh_missing);
        self.mesh_missing_data = qmark_data;
        
        self.centered_sphere = vertex_load("data/basic/centered-sphere.vbuff", self.format_pntc);
        self.centered_cube = vertex_load("data/basic/centered-cube.vbuff", self.format_pntc);
        self.centered_capsule = vertex_load("data/basic/centered-capsule.vbuff", self.format_pntc);
        
        self.grid = undefined;
        self.default_skybox = sprite_add(PATH_GRAPHICS + "b_sky_clouds_blue.png", 0, false, false, 0, 0);
    };
    
    static RecreateGrids = function() {
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        if (self.grid) vertex_delete_buffer(self.grid);
        self.grid = vertex_create_buffer();
        vertex_begin(self.grid, self.format_pnc);
        
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