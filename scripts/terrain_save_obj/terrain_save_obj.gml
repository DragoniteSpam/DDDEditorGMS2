/// @param filename

var fn = argument0;
var matfn = filename_change_ext(fn, ".mtl");
var terrain = Stuff.terrain;
var bytes = buffer_get_size(terrain.terrain_buffer_data);
var vertices = 0;
var scale = terrain.save_scale;
var precision = 256 - terrain.paint_precision;

// because regular string() doesn't give you very good precision
var mediump = 3;
var highp = 8;

var zupswap = terrain.export_swap_zup;
var uvswap = terrain.export_swap_uvs;

var active_mtl = "c-" + string(0xffffffff);
var mtl_warning = false;
var mtl_colors = ds_map_create();

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

for (var i = 0; i < bytes; i = i + terrain.format_size * 3) {
    var z0 = buffer_peek(terrain.terrain_buffer_data, i + 8, buffer_f32) * scale;
    var z1 = buffer_peek(terrain.terrain_buffer_data, i + 8 + terrain.format_size, buffer_f32) * scale;
    var z2 = buffer_peek(terrain.terrain_buffer_data, i + 8 + terrain.format_size * 2, buffer_f32) * scale;
    var c0 = buffer_peek(terrain.terrain_buffer_data, i + 32, buffer_u32);
    var c1 = buffer_peek(terrain.terrain_buffer_data, i + 32 + terrain.format_size, buffer_u32);
    var c2 = buffer_peek(terrain.terrain_buffer_data, i + 32 + terrain.format_size * 2, buffer_u32);
    
    if (terrain.export_all || z0 > 0 || z1 > 0 || z2 > 0) {
        for (var j = 0; j < terrain.format_size * 3; j = j + terrain.format_size) {
            var xx = buffer_peek(terrain.terrain_buffer_data, j + i, buffer_f32) * scale;
            var yy = buffer_peek(terrain.terrain_buffer_data, j + i + 4, buffer_f32) * scale;
            var zz = buffer_peek(terrain.terrain_buffer_data, j + i + 8, buffer_f32) * scale;
            var nx = buffer_peek(terrain.terrain_buffer_data, j + i + 12, buffer_f32);
            var ny = buffer_peek(terrain.terrain_buffer_data, j + i + 16, buffer_f32);
            var nz = buffer_peek(terrain.terrain_buffer_data, j + i + 20, buffer_f32);
            var xtex = buffer_peek(terrain.terrain_buffer_data, j + i + 24, buffer_f32);
            var ytex = buffer_peek(terrain.terrain_buffer_data, j + i + 28, buffer_f32);
            var color = buffer_peek(terrain.terrain_buffer_data, j + i + 32, buffer_u32);
            
            if (zupswap) {
                var t = xx;
                xx = yy;
                yy = zz;
                zz = t;
            }
            
            if (uvswap) {
                ytex = 1 - ytex;
            }
            
            buffer_write(buffer, buffer_text,
                "v " + string_format(xx, 1, mediump) + " " + string_format(yy, 1, mediump) + " " + string_format(zz, 1, mediump) + "\n" +
                "vn " + string_format(nx, 1, mediump) + " " + string_format(ny, 1, mediump) + " " + string_format(nz, 1, mediump) + "\n" +
                "vt " + string_format(xtex, 1, highp) + " " + string_format(ytex, 1, highp) + "\n"
            );
        }
        
        // If the color changes, you need to set the material accordingly (this may happen often with terrain that has been painted)
        var color_final = mean(c0, c1, c2);
        
        // you could easily end up exporting a million materials if you use the full range of colors,
        // so you may wish to not use the full range of colors

        // essentially, only the greatest x bits are used to store color information, since you're less
        // likely to notice if the lower one or two is off by one.
        //  - a precision of 8 means color channels can be described with eight bits (i.e. the full range),
        //  - a precision of 4 means color channels can be described with four bits (this would be 16-bit
        //      color depth,
        //  - a precision of 1 means color channels can be described with just one bit (i.e. just black,
        //      white, cyan, magenta, yellow, red, green and blue)
        // (this does not apply to d3d, since each individual vertex has its own color)
        
        var rr = round_ext((color_final & 0x000000ff), precision);
        var gg = round_ext((color_final & 0x0000ff00) >> 8, precision);
        var bb = round_ext((color_final & 0x00ff0000) >> 16, precision);
        var aa = round_ext((color_final & 0xff000000) >> 24, precision);
        /*rr = (rr >> precision) << precision;
        gg = (gg >> precision) << precision;
        bb = (bb >> precision) << precision;
        aa = (aa >> precision) << precision;*/
        This isn't spitting out the right numbers, why is this not spitting out the right numbers?
        color_final = rr | (gg << 8) | (bb << 16) | (aa << 24);
        
        if (!mtl_warning && color_final != c0) {
            dialog_create_notice(noone, "The Wavefront OBJ file format does not supprt per-vertex color / alpha values (only per-face) - see the Material Termplate Library specification for more information. The average value will be used instead for each face.",
                "Hey!", "Okay", 540, 240
            );
            mtl_warning = true;
        }
        
        var mtl_name = "c-" + string(color_final);
        
        if (!ds_map_exists(mtl_colors, mtl_name)) {
            mtl_colors[? mtl_name] = color_final;
        }
        
        if (mtl_name != active_mtl) {
            active_mtl = mtl_name;
            var rr = (color_final & 0x000000ff) / 255;
            var gg = ((color_final & 0x0000ff00) >> 8) / 255;
            var bb = ((color_final & 0x00ff0000) >> 16) / 255;
            var aa = ((color_final & 0xff000000) >> 24) / 255;
            buffer_write(buffer, buffer_text, "usemtl " + mtl_name + "\n");
            buffer_write(buffer_mtl, buffer_text,
                "newmtl " + mtl_name + "\n" +
                "Kd " + string_format(rr, 1, mediump) + " " + string_format(gg, 1, mediump) + " " + string_format(bb, 1, mediump) + "\n" +
                "d " + string_format(aa, 1, mediump) + "\nillum 2\n\n"
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

buffer_poke(buffer, addr_vertex_count, buffer_text, string_pad(vertices, "0", 8));
buffer_poke(buffer_mtl, addr_mtl_count, buffer_text, string_pad(ds_map_size(mtl_colors), "0", 8));

buffer_save_ext(buffer, fn, 1, buffer_tell(buffer));
buffer_save_ext(buffer_mtl, matfn, 1, buffer_tell(buffer_mtl));

buffer_delete(buffer);
buffer_delete(buffer_mtl);

ds_map_destroy(mtl_colors);