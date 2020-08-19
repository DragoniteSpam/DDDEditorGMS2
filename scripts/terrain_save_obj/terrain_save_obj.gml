/// @param filename
function terrain_save_obj(argument0) {

	var fn = argument0;
	var matfn = filename_change_ext(fn, ".mtl");
	var terrain = Stuff.terrain;
	var bytes = buffer_get_size(terrain.terrain_buffer_data);
	var vertices = 0;
	var scale = terrain.save_scale;

	var fx = sprite_get_width(terrain.texture) / terrain.texture_width;
	var fy = sprite_get_height(terrain.texture) / terrain.texture_height;

	// because regular string() doesn't give you very good precision
	var mediump = 4;
	var highp = 8;

	var zupswap = terrain.export_swap_zup;
	var uvswap = terrain.export_swap_uvs;

	var active_mtl = "a-1";
	var mtl_warning = false;
	var mtl_colors = ds_map_create();
	var blender_color_warning = false;

	var buffer = buffer_create(1000000, buffer_grow, 1);
	var buffer_mtl = buffer_create(1000, buffer_grow, 1);
	buffer_write(buffer, buffer_text, "## DDD Terrain OBJ file: " + filename_name(matfn) + "\n# Vertices: ");
	var addr_vertex_count = buffer_tell(buffer);
	buffer_write(buffer, buffer_text, "00000000\nmtllib " + filename_name(matfn) + "\n\n");

	buffer_write(buffer_mtl, buffer_text, "## DDD Terrain MTL file: " + filename_name(matfn) + "\n# Material count: ");
	var addr_mtl_count = buffer_tell(buffer_mtl);
	// If you exceed this you're going to have a bad time
	buffer_write(buffer_mtl, buffer_text, "00000000\n\n");

	buffer_write(buffer, buffer_text, "usemtl " + active_mtl + "\n");
	buffer_write(buffer_mtl, buffer_text, "newmtl " + active_mtl + "\nKd 1 1 1\nd 1\nillum 2\n\n");

	for (var i = 0; i < bytes; i = i + VERTEX_SIZE_BASIC * 3) {
	    var z0 = buffer_peek(terrain.terrain_buffer_data, i + 8, buffer_f32) * scale;
	    var z1 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_BASIC, buffer_f32) * scale;
	    var z2 = buffer_peek(terrain.terrain_buffer_data, i + 8 + VERTEX_SIZE_BASIC * 2, buffer_f32) * scale;
	    var c0 = buffer_peek(terrain.terrain_buffer_data, i + 32, buffer_u32);
	    var c1 = buffer_peek(terrain.terrain_buffer_data, i + 32 + VERTEX_SIZE_BASIC, buffer_u32);
	    var c2 = buffer_peek(terrain.terrain_buffer_data, i + 32 + VERTEX_SIZE_BASIC * 2, buffer_u32);
    
	    var aa0 = ((c0 & 0xff000000) >> 24) / 0xff;
	    var aa1 = ((c1 & 0xff000000) >> 24) / 0xff;
	    var aa2 = ((c2 & 0xff000000) >> 24) / 0xff;
    
	    if (terrain.export_all || z0 > 0 || z1 > 0 || z2 > 0) {
	        for (var j = 0; j < VERTEX_SIZE_BASIC * 3; j = j + VERTEX_SIZE_BASIC) {
	            var xx = buffer_peek(terrain.terrain_buffer_data, j + i, buffer_f32) * scale;
	            var yy = buffer_peek(terrain.terrain_buffer_data, j + i + 4, buffer_f32) * scale;
	            var zz = buffer_peek(terrain.terrain_buffer_data, j + i + 8, buffer_f32) * scale;
	            var nx = buffer_peek(terrain.terrain_buffer_data, j + i + 12, buffer_f32);
	            var ny = buffer_peek(terrain.terrain_buffer_data, j + i + 16, buffer_f32);
	            var nz = buffer_peek(terrain.terrain_buffer_data, j + i + 20, buffer_f32);
	            var xtex = buffer_peek(terrain.terrain_buffer_data, j + i + 24, buffer_f32) * fx;
	            var ytex = buffer_peek(terrain.terrain_buffer_data, j + i + 28, buffer_f32) * fy;
	            var color = buffer_peek(terrain.terrain_buffer_data, j + i + 32, buffer_u32);
            
	            if (color & 0x00ffffff != 0x00ffffff) {
	                blender_color_warning = true;
	            }
            
	            if (zupswap) {
	                var t = xx;
	                xx = yy;
	                yy = zz;
	                zz = t;
	            }
            
	            if (uvswap) {
	                ytex = 1 - ytex;
	            }
            
	            var rr = (color & 0x000000ff) / 0xff;
	            var gg = ((color & 0x0000ff00) >> 8) / 0xff;
	            var bb = ((color & 0x00ff0000) >> 16) / 0xff;
            
	            buffer_write(buffer, buffer_text,
	                "v " + string_format(xx, 1, mediump) + " " + string_format(yy, 1, mediump) + " " + string_format(zz, 1, mediump) +  " " +
	                    string_format(rr, 1, highp) + " " + string_format(gg, 1, highp) + " " + string_format(bb, 1, highp) + "\n" +
	                "vn " + string_format(nx, 1, mediump) + " " + string_format(ny, 1, mediump) + " " + string_format(nz, 1, mediump) + "\n" +
	                "vt " + string_format(xtex, 1, highp) + " " + string_format(ytex, 1, highp) + "\n"
	            );
	        }
        
	        // vertex colors can be stored with the vertices themselves, but i don't know if alpha can
	        // and this should be Good Enough anyway
        
	        var aa = mean(aa0, aa1, aa2);
        
	        if (aa != aa0) {
	            mtl_warning = true;
	        }
        
	        var mtl_name = "a-" + string(aa);
        
	        if (!ds_map_exists(mtl_colors, mtl_name)) {
	            mtl_colors[? mtl_name] = aa;
	        }
        
	        if (mtl_name != active_mtl) {
	            active_mtl = mtl_name;
            
	            buffer_write(buffer, buffer_text, "usemtl " + mtl_name + "\n");
	            buffer_write(buffer_mtl, buffer_text,
	                "newmtl " + mtl_name + "\n" +
	                "Kd 1 1 1\n" +
	                "d " + string_format(aa, 1, mediump) + "\n" +
	                "map_Ka " + terrain.texture_name + "\n" +
	                "map_Kd " + terrain.texture_name + "\n" +
	                "illum 2\n\n"
	            );
	        }
        
	        // After that ordeal you can save the actual face
        
	        buffer_write(buffer, buffer_text,
	            "f " + string(vertices + 1) + "/" + string(vertices + 1) + "/" + string(vertices + 1) + " " +
	            string(vertices + 2) + "/" + string(vertices + 2) + "/" + string(vertices + 2) + " " +
	            string(vertices + 3) + "/" + string(vertices + 3) + "/" + string(vertices + 3) + "\n\n"
	        );
        
	        vertices = vertices + 3;
	    }
	}

	var warning_str = "";
	var warning_size = 0;

	if (mtl_warning) {
	    warning_str = warning_str + "The Wavefront OBJ file format does not supprt per-vertex alpha values (only per-face) - see the Material Termplate Library specification for more information. The average alpha value will be used instead for each face.\n\n";
	    warning_size = warning_size + 160;
	}

	if (blender_color_warning) {
	    warning_str = warning_str + "This will be exported with vertex colors. Some software can import OBJ files that use vertex colors, but others (most notably, Blender) do not. You may want to check to see if the software you intend to use this with supports vertex colors.\n\n";
	    warning_size = warning_size + 160;
	}

	if (string_length(warning_str) > 0) {
	    var dialog = dialog_create_notice(noone, warning_str, "Warnings!", "Okay", 720, max(240, warning_size), fa_left);
	}

	buffer_poke(buffer, addr_vertex_count, buffer_text, string_pad(vertices, "0", 8));
	buffer_poke(buffer_mtl, addr_mtl_count, buffer_text, string_pad(ds_map_size(mtl_colors), "0", 8));

	buffer_save_ext(buffer, fn, 1, buffer_tell(buffer));
	buffer_save_ext(buffer_mtl, matfn, 1, buffer_tell(buffer_mtl));
	sprite_save(terrain.texture, 0, filename_dir(fn) + "\\" + terrain.texture_name, terrain.texture_width, terrain.texture_height);

	buffer_delete(buffer);
	buffer_delete(buffer_mtl);

	ds_map_destroy(mtl_colors);


}