function EditorGraphics() constructor {
    self.Init = function() {
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
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        self.format_pntc = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        vertex_format_add_normal();
        self.format_pntcb = vertex_format_end();
        
        #region basic grids
        self.grid_centered = vertex_load("data/basic/grid_centered.vbuff", self.format_pntcb);
        self.wire_box = vertex_load("data/basic/wire_box.vbuff", self.format_pntcb);
        self.wire_sphere = vertex_load("data/basic/wire_sphere.vbuff", self.format_pntcb);
        self.wire_capsule = vertex_load("data/basic/wire_capsule.vbuff", self.format_pntcb);
        #endregion
        
        #region 3D coordinate systems
        self.axes = vertex_load("data/basic/axes.vbuff", self.format_pntcb);
        self.axes_centered = vertex_load("data/basic/axes_centered.vbuff", self.format_pntcb);
        self.axes_translation = vertex_load("data/basic/translation.vbuff", self.format_pntcb);
        self.axes_rotation = vertex_load("data/basic/rotation.vbuff", self.format_pntcb);
        #endregion
        
        self.basic_cage = vertex_load("data/basic/cage.vbuff", self.format_pntcb);
        self.indexed_cage = vertex_load("data/basic/cage-indexed.vbuff", self.format_pntcb);
        self.indexed_cage_full = vertex_load("data/basic/cage-indexed-full.vbuff", self.format_pntcb);
        self.basic_cube = vertex_load("data/basic/cube.vbuff", self.format_pntcb);
        // load both buffers
        var missing_data = buffer_load("data/basic/missing_autotile.vbuff");
        self.missing_autotile = vertex_create_buffer_from_buffer(missing_data, self.format_pntcb);
        vertex_freeze(self.missing_autotile);
        self.missing_autotile_raw = missing_data;
        self.indexed_cube = vertex_load("data/basic/cube-indexed.vbuff", self.format_pntcb);
        self.base_npc = vertex_load("data/basic/base-npc.vbuff", self.format_pntcb);
        self.skybox_base = vertex_load("data/basic/skybox-base.vbuff", self.format_pntcb);
        var qmark_data = buffer_load("data/basic/missing.vbuff");
        self.mesh_missing = vertex_create_buffer_from_buffer(qmark_data, self.format_pntcb);
        vertex_freeze(self.mesh_missing);
        self.mesh_missing_data = qmark_data;
        
        self.grid = undefined;
        self.default_skybox = sprite_add(PATH_GRAPHICS + "b_sky_clouds_blue.png", 0, false, false, 0, 0);
    };
    
    self.DrawWireBox = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_utility_wireframe);
        vertex_submit(Stuff.graphics.wire_box, pr_linelist, -1);
    };
    
    self.DrawWireCapsule = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_utility_wireframe);
        vertex_submit(Stuff.graphics.wire_capsule, pr_linelist, -1);
    };
    
    self.DrawWireSphere = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_utility_wireframe);
        vertex_submit(Stuff.graphics.wire_sphere, pr_linelist, -1);
    };
    
    self.DrawGridCentered = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_utility_wireframe);
        vertex_submit(Stuff.graphics.grid_centered, pr_linelist, -1);
    };
    
    self.DrawAxes = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
    };
    
    self.DrawAxesCentered = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_basic_colorsDrawAxesCentered);
        vertex_submit(Stuff.graphics.axes_centered, pr_linelist, -1);
    };
    
    self.DrawAxesTranslation = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes_translation, pr_linelist, -1);
    };
    
    self.DrawAxesRotation = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 0, ys = 0, zs = 0) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        shader_set(shd_basic_colors);
        vertex_submit(Stuff.graphics.axes_rotation, pr_linelist, -1);
    };
    
    self.RecreateGrids = function() {
        var map = Stuff.map.active_map;
        var map_contents = map.contents;
        
        if (self.grid) vertex_delete_buffer(self.grid);
        self.grid = vertex_create_buffer();
        vertex_begin(self.grid, self.format_pntcb);
        
        for (var i = 0; i <= map.xx; i++) {
            var xx = i * TILE_WIDTH;
            var yy = map.yy * TILE_HEIGHT;
            
            vertex_position_3d(self.grid, xx, 0, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_texcoord(self.grid, 0, 0);
            vertex_colour(self.grid, c_white, 1);
            vertex_normal(self.grid, 0, 0, 0);
            
            vertex_position_3d(self.grid, xx, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_texcoord(self.grid, 0, 0);
            vertex_colour(self.grid, c_white, 1);
            vertex_normal(self.grid, 0, 0, 0);
        }
        
        for (var i = 0; i <= map.yy; i++) {
            var xx = map.xx * TILE_HEIGHT;
            var yy = i * TILE_WIDTH;
            
            vertex_position_3d(self.grid, 0, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_texcoord(self.grid, 0, 0);
            vertex_colour(self.grid, c_white, 1);
            vertex_normal(self.grid, 0, 0, 0);
            
            vertex_position_3d(self.grid, xx, yy, 0);
            vertex_normal(self.grid, 0, 0, 1);
            vertex_texcoord(self.grid, 0, 0);
            vertex_colour(self.grid, c_white, 1);
            vertex_normal(self.grid, 0, 0, 0);
        }
        
        vertex_end(self.grid);
        vertex_freeze(self.grid);
    };
}