function EditorGraphics() constructor {
    self.Init = function() {
        #macro TEX_MISSING Stuff.graphics.tex_missing
        self.tex_missing = sprite_get_texture(b_tileset_magenta, 0);
        
        gpu_set_alphatestenable(true);
        gpu_set_alphatestref(20);
        gpu_set_tex_repeat(true);
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_texcoord();
        vertex_format_add_colour();
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // tangent vectors
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // bitangent vectors
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);      // barycentric coordinates
        self.format = vertex_format_end();
        self.format_size = vertex_format_get_info(self.format).stride;
        
        meshops_init(self.format_size);
        show_debug_message("MeshOps version: " + string(meshops_version()));
        show_debug_message("AssOps version: " + string(assops_version()));
        
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
        vertex_format_add_custom(vertex_type_float3, vertex_usage_colour);
        self.format_pntcb = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_colour();
        self.format_pc = vertex_format_end();
        
        #region basic grids
        self.grid_centered = vertex_load("data/basic/grid_centered.vbuff", self.format_pc);
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
        self.indexed_cube = vertex_load("data/basic/cube-indexed.vbuff", self.format_pntcb);
        self.base_npc = vertex_load("data/basic/base-npc.vbuff", self.format_pntcb);
        self.skybox_base = vertex_load("data/basic/skybox-base.vbuff", self.format_pntcb);
        self.mesh_missing = vertex_load("data/basic/missing.vbuff", self.format_pntcb);
        self.missing_autotile = vertex_load("data/basic/missing_autotile.vbuff", self.format_pntcb);
        
        self.default_skybox = sprite_add(PATH_GRAPHICS + "b_sky_clouds_blue.png", 0, false, false, 0, 0);
    };
    
    self.DrawWireBox = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1, color = c_wireframe_mesh_col_box) {
        var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, xs, ys, zs);
        var mat_rot = matrix_multiply(mat_scale, matrix_build(0, 0, 0, xr, yr, zr, 1, 1, 1));
        var mat = matrix_multiply(mat_rot, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
        var mat_source = matrix_get(matrix_world);
        matrix_set(matrix_world, matrix_multiply(mat, mat_source));
        var shader = shader_current();
        var cull = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        shader_set(shd_utility_wireframe);
        wireframe_enable(1, 1000000, color);
        vertex_submit(self.wire_box, pr_trianglelist, -1);
        wireframe_disable();
        matrix_set(matrix_world, mat_source);
        shader_set(shader);
        gpu_set_cullmode(cull);
    };
    
    self.DrawWireCapsule = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1, color = c_wireframe_mesh_col_capsule) {
        var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, xs, ys, zs);
        var mat_rot = matrix_multiply(mat_scale, matrix_build(0, 0, 0, xr, yr, zr, 1, 1, 1));
        var mat = matrix_multiply(mat_rot, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
        var mat_source = matrix_get(matrix_world);
        matrix_set(matrix_world, matrix_multiply(mat, mat_source));
        var shader = shader_current();
        var cull = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        shader_set(shd_utility_wireframe);
        wireframe_enable(1, 1000000, color);
        vertex_submit(self.wire_capsule, pr_trianglelist, -1);
        wireframe_disable();
        matrix_set(matrix_world, mat_source);
        shader_set(shader);
        gpu_set_cullmode(cull);
    };
    
    self.DrawWireSphere = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1, color = c_wireframe_mesh_col_sphere) {
        var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, xs, ys, zs);
        var mat_rot = matrix_multiply(mat_scale, matrix_build(0, 0, 0, xr, yr, zr, 1, 1, 1));
        var mat = matrix_multiply(mat_rot, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
        var mat_source = matrix_get(matrix_world);
        matrix_set(matrix_world, matrix_multiply(mat, mat_source));
        var shader = shader_current();
        var cull = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        shader_set(shd_utility_wireframe);
        wireframe_enable(1, 1000000, color);
        vertex_submit(self.wire_sphere, pr_trianglelist, -1);
        wireframe_disable();
        matrix_set(matrix_world, mat_source);
        shader_set(shader);
        gpu_set_cullmode(cull);
    };
    
    self.DrawGridCentered = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_utility_grid);
        vertex_submit(self.grid_centered, pr_linelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawMapGrid = function(x, y, z, w, h, cursor_position = undefined, tile_width = TILE_WIDTH, tile_height = TILE_HEIGHT, tile_depth = TILE_DEPTH, colour = c_black, thickness = 1) {
        var shader = shader_current();
        static u_grid_size = shader_get_uniform(shd_utility_grid, "u_GridSize");
        static u_grid_thickness = shader_get_uniform(shd_utility_grid, "u_GridThickness");
        static u_grid_color = shader_get_uniform(shd_utility_grid, "u_GridColor");
        
        static u_cursor_enabled = shader_get_uniform(shd_utility_grid, "u_CursorEnabled");
        static u_cursor_position = shader_get_uniform(shd_utility_grid, "u_CursorPosition");
        static u_cursor_affect_half_size = shader_get_uniform(shd_utility_grid, "u_CursorAffectHalfSize");
        
        matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
        shader_set(shd_utility_grid);
        shader_set_uniform_f(u_grid_size, tile_width, tile_height);
        shader_set_uniform_f(u_grid_thickness, thickness);
        shader_set_uniform_f(u_grid_color, colour_get_red(colour) / 0xff, colour_get_green(colour) / 0xff, colour_get_blue(colour) / 0xff);
        
        if (cursor_position == undefined) {
            shader_set_uniform_f(u_cursor_enabled, 0);
        } else {
            var px = ((cursor_position.x div tile_width) + 0.5) * tile_width;
            var py = ((cursor_position.y div tile_height) + 0.5) * tile_height;
            //var pz = ((cursor_position.z div tile_depth) + 0.5) * tile_depth;
            var pz = 0.5 * tile_depth;
            shader_set_uniform_f(u_cursor_enabled, 1);
            shader_set_uniform_f(u_cursor_position, px, py, pz);
            // not sure if there'll be a reason to change this later or not
            shader_set_uniform_f(u_cursor_affect_half_size, tile_width / 2, tile_height / 2, tile_depth / 2);
        }
        draw_sprite_stretched(spr_pixel, 0, 0, 0, w, h);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawAxes = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_basic_colors);
        vertex_submit(self.axes, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawAxesCentered = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_basic_colors);
        vertex_submit(self.axes_centered, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawAxesTranslation = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_basic_colors);
        vertex_submit(self.axes_translation, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawAxesRotation = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_basic_colors);
        vertex_submit(self.axes_rotation, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
    
    self.DrawBasicCage = function(x = 0, y = 0, z = 0, xr = 0, yr = 0, zr = 0, xs = 1, ys = 1, zs = 1) {
        matrix_set(matrix_world, matrix_build(x, y, z, xr, yr, zr, xs, ys, zs));
        var shader = shader_current();
        shader_set(shd_basic_colors);
        vertex_submit(self.basic_cage, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shader);
    };
}