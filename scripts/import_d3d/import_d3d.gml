/// @param filename
/// @param [complete-object?]
/// @param [include-raw-buffer?]
/// @param [existing-object]
/// @param [replace-index]
function import_d3d() {
    // returns either a vertex buffer or an array of [vertex buffer, data buffer] depending
    // on what you ask it for
    // this is VERY bad but i don't want to write more than one d3d importers, or to offload
    // the d3d code to somewhere else, so it stays like this for now
    
    var fn = argument[0];
    // setting "everything" to false will mean only the vertex buffer is returned
    var everything = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
    var raw_buffer = (argument_count > 2 && argument[2] != undefined) ? argument[2] : false;
    var existing = (argument_count > 3 && argument[3] != undefined) ? argument[3] : noone;
    var replace_index = (argument_count > 4 && argument[4] != undefined) ? argument[4] : -1;
    var data_added = false;
    
    var f = file_text_open_read(fn);
    file_text_readln(f);
    var n = file_text_read_real(f) - 2;
    file_text_readln(f);
    
    var vbuffer = vertex_create_buffer();
    if (everything) {
        var wbuffer = vertex_create_buffer();
        var cshape = c_shape_create();
    }
    
    vertex_begin(vbuffer, Stuff.graphics.vertex_format);
    if (everything) {
        vertex_begin(wbuffer, Stuff.graphics.vertex_format);
        c_shape_begin_trimesh();
    }
    
    var vc = 0;
    
    var xx = [0, 0, 0];
    var yy = [0, 0, 0];
    var zz = [0, 0, 0];
    
    var nx = [0, 0, 0];
    var ny = [0, 0, 0];
    var nz = [0, 0, 0];
    var xtex = [0, 0, 0];
    var ytex = [0, 0, 0]
    var color = [0, 0, 0];
    var alpha = [0, 0, 0];
    
    var minx = 0;
    var miny = 0;
    var minz = 0;
    var maxx = 0;
    var maxy = 0;
    var maxz = 0;
    
    #macro tri_type_list 4
    #macro tri_type_strip 5
    #macro tri_type_fan 6
    var tri_type = tri_type_list;
    
    #region big fat loop
    while (!file_text_eof(f)) {
        var type = file_text_read_real(f);
        
        var skip = false;
        
        switch (type) {
            case 0: tri_type = file_text_read_real(f); file_text_readln(f); skip = true; break;
            case 1: file_text_readln(f); skip = true; break;
            case 2: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 3: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 4: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 5: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 6: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 7: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 8: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 9: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            default: wtf("Unsupported structure in " + fn + ", skipping. Please convert your primitive shapes into triangles. Thank."); file_text_readln(f); skip = true; break;
        }
        
        if (skip) continue;
        
        // the texture pages are 4k, so this is four pixels squared
        xtex[vc] = round_ext(xtex[vc], 1 / 1024);
        ytex[vc] = round_ext(ytex[vc], 1 / 1024);
        
        minx = min(minx, xx[vc]);
        miny = min(miny, yy[vc]);
        minz = min(minz, zz[vc]);
        maxx = max(maxx, xx[vc]);
        maxy = max(maxy, yy[vc]);
        maxz = max(maxz, zz[vc]);
        
        data_added = true;
        
        vc++;
        
        if (vc == 3) {
            vertex_point_complete(vbuffer, xx[0], yy[0], zz[0], nx[0], ny[0], nz[0], xtex[0], ytex[0], color[0], alpha[0]);
            vertex_point_complete(vbuffer, xx[1], yy[1], zz[1], nx[1], ny[1], nz[1], xtex[1], ytex[1], color[1], alpha[1]);
            vertex_point_complete(vbuffer, xx[2], yy[2], zz[2], nx[2], ny[2], nz[2], xtex[2], ytex[2], color[2], alpha[2]);
            
            if (everything) {
                vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
                vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
                vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
                vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
                vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
                vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
                c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
            }
            
            switch (tri_type) {
                case tri_type_list:
                    xx[0] = 0; xx[1] = 0; xx[2] = 0;
                    yy[0] = 0; yy[1] = 0; yy[2] = 0;
                    zz[0] = 0; zz[1] = 0; zz[2] = 0;
                    nx[0] = 0; nx[1] = 0; nx[2] = 0;
                    ny[0] = 0; ny[1] = 0; ny[2] = 0;
                    nz[0] = 0; nz[1] = 0; nz[2] = 0;
                    xtex[0] = 0; xtex[1] = 0; xtex[2] = 0;
                    ytex[0] = 0; ytex[1] = 0; ytex[2] = 0;
                    color[0] = c_white; color[1] = c_white; color[2] = c_white;
                    alpha[0] = 1; alpha[1] = 1; alpha[2] = 1;
                    vc = 0;
                    break;
                case tri_type_strip:
                    xx[0] = xx[1]; xx[1] = xx[2]; xx[2] = 0;
                    yy[0] = yy[1]; yy[1] = yy[2]; yy[2] = 0;
                    zz[0] = zz[1]; zz[1] = zz[2]; zz[2] = 0;
                    nx[0] = nx[1]; nx[1] = nx[2]; nx[2] = 0;
                    ny[0] = ny[1]; ny[1] = ny[2]; ny[2] = 0;
                    nz[0] = nz[1]; nz[1] = nz[2]; nz[2] = 0;
                    xtex[0] = xtex[1]; xtex[1] = xtex[2]; xtex[2] = 0;
                    ytex[0] = ytex[1]; ytex[1] = ytex[2]; ytex[2] = 0;
                    color[0] = color[1]; color[1] = color[2]; color[2] = c_white;
                    alpha[0] = alpha[1]; alpha[1] = alpha[2]; alpha[2] = 1;
                    vc = 2;
                    break;
                case tri_type_fan:
                    xx[1] = xx[2]; xx[2] = 0;
                    yy[1] = yy[2]; yy[2] = 0;
                    zz[1] = zz[2]; zz[2] = 0;
                    nx[1] = nx[2]; nx[2] = 0;
                    ny[1] = ny[2]; ny[2] = 0;
                    nz[1] = nz[2]; nz[2] = 0;
                    xtex[1] = xtex[2]; xtex[2] = 0;
                    ytex[1] = ytex[2]; ytex[2] = 0;
                    color[1] = color[2]; color[2] = c_white;
                    alpha[1] = alpha[2]; alpha[2] = 1;
                    vc = 2;
                    break;
            }
        }
    }
    #endregion
    
    file_text_close(f);
    vertex_end(vbuffer);
    
    var dbuffer = raw_buffer ? buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1) : noone;
    
    if (!data_added) {
        vertex_delete_buffer(vbuffer);
        vbuffer = noone;
    }
    
    if (everything) {
        if (data_added) {
            vertex_end(wbuffer);
            c_shape_end_trimesh(cshape);
        } else {
            vertex_delete_buffer(wbuffer);
            c_shape_destroy(cshape);
        }
        
        var base_name = filename_change_ext(filename_name(fn), "");
        var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
        
        if (!existing) {
            mesh.xmin = 0;
            mesh.ymin = 0;
            mesh.zmin = 0;
            mesh.xmax = 1;
            mesh.ymax = 1;
            mesh.zmax = 1;
            
            mesh.name = base_name;
            data_mesh_recalculate_bounds(mesh);
            internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
        }
        
        if (data_added) {
            mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1), vbuffer, wbuffer, undefined, base_name, replace_index, fn);
            if (!mesh.cshape) {
                mesh.cshape = cshape;
            } else {
                c_shape_destroy(cshape);
            }
            
            vertex_freeze(vbuffer);
            vertex_freeze(wbuffer);
        }
        
        return mesh;
    }
    
    return raw_buffer ? [vbuffer, dbuffer] : vbuffer;
}