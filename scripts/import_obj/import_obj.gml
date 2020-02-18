/// @param filename
/// @param [complete-object?]
/// @param [adjust-UVs?]

var fn = argument[0];
// setting "everything" to false will mean only the vertex buffer is returned
var everything = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
var adjust = (argument_count > 2 && argument[2] != undefined) ? argument[2] : true;
var data_added = false;

var mfn = filename_change_ext(fn, ".mtl");

if (file_exists(fn)) {
    var active_mtl = "None";
    var mtl_alpha = ds_map_create();
    var mtl_color_r = ds_map_create();
    var mtl_color_g = ds_map_create();
    var mtl_color_b = ds_map_create();
    ds_map_set(mtl_alpha, "None", 1);
    ds_map_set(mtl_color_r, "None", 255);
    ds_map_set(mtl_color_g, "None", 255);
    ds_map_set(mtl_color_b, "None", 255);
    
    if (file_exists(mfn)) {
        var matfile = file_text_open_read(mfn);
        var mtl_name = "";
        
        while (!file_text_eof(matfile)) {
            var line = file_text_read_string(matfile);
            file_text_readln(matfile);
            var spl = split(line, " ");
            switch (ds_queue_dequeue(spl)) {
                case "newmtl":
                    mtl_name = ds_queue_dequeue(spl);
                    break;
                case "Kd":  // Diffuse color (the color we're concerned with)
                    mtl_color_r[? mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                    mtl_color_g[? mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                    mtl_color_b[? mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                    break;
                case "d":   // "dissolved" (alpha)
                    mtl_alpha[? mtl_name] = real(ds_queue_dequeue(spl));
                    break;
                case "Tr":  // "transparent" (1 - alpha)
                    mtl_alpha[? mtl_name] = 1 - real(ds_queue_dequeue(spl));
                    break;
                default:    // There are way more attributes available than I'm going to use later - maybe
                    break;
            }
            ds_queue_destroy(spl);
        }
        file_text_close(matfile);
    }
    
    var f = file_text_open_read(fn);
    var illegal = false;
    var line_number = 0;
    
    var v_x = ds_list_create();
    var v_y = ds_list_create();
    var v_z = ds_list_create();
    var v_nx = ds_list_create();
    var v_ny = ds_list_create();
    var v_nz = ds_list_create();
    var v_xtex = ds_list_create();
    var v_ytex = ds_list_create();
    
    var xx = [0, 0, 0];
    var yy = [0, 0, 0];
    var zz = [0, 0, 0];
    var nx = [0, 0, 0];
    var ny = [0, 0, 0];
    var nz = [0, 0, 0];
    var r = [0, 0, 0];
    var g = [0, 0, 0];
    var b = [0, 0, 0];
    var a = [0, 0, 0];
    var xtex = [0, 0, 0];
    var ytex = [0, 0, 0];
    
    var temp_vertices = ds_list_create();
    
    while (!file_text_eof(f) && !illegal) {
        line_number++;
        var str = file_text_read_string(f);
        var q = split(str, " ", false, false);
        file_text_readln(f);
        
        switch (ds_queue_dequeue(q)) {
            case "v":
                if (ds_queue_size(q) >= 3) {
                    ds_list_add(v_x, real(ds_queue_dequeue(q)));
                    ds_list_add(v_y, real(ds_queue_dequeue(q)));
                    ds_list_add(v_z, real(ds_queue_dequeue(q)));
                } else {
                    // @gml update try-catch
                    show_message("Malformed vertex found (line " + string(line_number) + ")");
                    illegal = true;
                }
                break;
            case "vt":
                if (ds_queue_size(q) >= 2) {
                    ds_list_add(v_xtex, real(ds_queue_dequeue(q)));
                    ds_list_add(v_ytex, real(ds_queue_dequeue(q)));
                } else {
                    // @gml update try-catch
                    show_message("Malformed vertex texture found (line " + string(line_number) + ")");
                    illegal = true;
                }
                break;
            case "vn":
                if (ds_queue_size(q) >= 3) {
                    ds_list_add(v_nx, real(ds_queue_dequeue(q)));
                    ds_list_add(v_ny, real(ds_queue_dequeue(q)));
                    ds_list_add(v_nz, real(ds_queue_dequeue(q)));
                } else {
                    // @gml update try-catch
                    show_message("Malformed vertex normal found (line " + string(line_number) + ")");
                    illegal = true;
                }
                break;
            case "usemtl":
                active_mtl = ds_queue_dequeue(q);
                break;
            case "f":
                if (ds_queue_size(q) >= 3) {
                    var s = ds_queue_size(q);
                    for (var i = 0; i < s; i++) {
                        var vertex_q = split(ds_queue_dequeue(q), "/", false, true);
                        switch (ds_queue_size(vertex_q)) {
                            case 1:
                                var vert = real(ds_queue_dequeue(vertex_q)) - 1;    // each of these are -1 because they start indexing from 1 instead of 0. Why?
                                xx[i] = v_x[| vert];
                                yy[i] = v_y[| vert];
                                zz[i] = v_z[| vert];
                                nx[i] = 0;
                                ny[i] = 0;
                                ny[i] = 1;
                                xtex[i] = 0;
                                ytex[i] = 0;
                                r[i] = ds_map_exists(mtl_color_r, active_mtl) ? mtl_color_r[? active_mtl] : 255;
                                g[i] = ds_map_exists(mtl_color_g, active_mtl) ? mtl_color_g[? active_mtl] : 255;
                                b[i] = ds_map_exists(mtl_color_b, active_mtl) ? mtl_color_b[? active_mtl] : 255;
                                a[i] = ds_map_exists(mtl_alpha, active_mtl) ? mtl_alpha[? active_mtl] : 1;
                                break;
                            case 2:
                                var vert = real(ds_queue_dequeue(vertex_q)) - 1;
                                var tex = real(ds_queue_dequeue(vertex_q)) - 1;
                                xx[i] = v_x[| vert];
                                yy[i] = v_y[| vert];
                                zz[i] = v_z[| vert];
                                xtex[i] = v_xtex[| tex];
                                ytex[i] = v_ytex[| tex];
                                nx[i] = 0;
                                ny[i] = 0;
                                ny[i] = 1;
                                r[i] = ds_map_exists(mtl_color_r, active_mtl) ? mtl_color_r[? active_mtl] : 255;
                                g[i] = ds_map_exists(mtl_color_g, active_mtl) ? mtl_color_g[? active_mtl] : 255;
                                b[i] = ds_map_exists(mtl_color_b, active_mtl) ? mtl_color_b[? active_mtl] : 255;
                                a[i] = ds_map_exists(mtl_alpha, active_mtl) ? mtl_alpha[? active_mtl] : 1;
                                break;
                            case 3:
                                var vert = real(ds_queue_dequeue(vertex_q)) - 1;
                                var tex = real(ds_queue_dequeue(vertex_q)) - 1;
                                var normal = real(ds_queue_dequeue(vertex_q))-1;
                                xx[i] = v_x[| vert];
                                yy[i] = v_y[| vert];
                                zz[i] = v_z[| vert];
                                nx[i] = v_nx[| normal];
                                ny[i] = v_ny[| normal];
                                nz[i] = v_nz[| normal];
                                xtex[i] = v_xtex[| tex];
                                ytex[i] = v_ytex[| tex];
                                r[i] = ds_map_exists(mtl_color_r, active_mtl) ? mtl_color_r[? active_mtl] : 255;
                                g[i] = ds_map_exists(mtl_color_g, active_mtl) ? mtl_color_g[? active_mtl] : 255;
                                b[i] = ds_map_exists(mtl_color_b, active_mtl) ? mtl_color_b[? active_mtl] : 255;
                                a[i] = ds_map_exists(mtl_alpha, active_mtl) ? mtl_alpha[? active_mtl] : 1;
                                break;
                        }
                    }
                    // Only the first triangle of a face will be added because i can't be bothered with complex faces
                    for (var i = 1; i < array_length_1d(xx) - 1; i++) {
                        ds_list_add(temp_vertices, [xx[0], yy[0], zz[0], nx[0], ny[0], nz[0], xtex[0], ytex[0], (b[0] << 16) | (g[0] << 8) | r[0], a[0]]);
                        ds_list_add(temp_vertices, [xx[i], yy[i], zz[i], nx[i], ny[i], nz[i], xtex[i], ytex[i], (b[i] << 16) | (g[i] << 8) | r[i], a[i]]);
                        ds_list_add(temp_vertices, [xx[i + 1], yy[i + 1], zz[i + 1], nx[i + 1], ny[i + 1], nz[i + 1], xtex[i + 1], ytex[i + 1], (b[i + 1] << 16) | (g[i + i] << 8) | r[i + 1], a[i + 1]]);
                    }
                    ds_queue_destroy(vertex_q);
                } else {
                    // @gml update try-catch
                    show_message("Malformed face found (tee hee) (line " + string(line_number) + ")");
                    illegal = true;
                }
                break;
            case "s":   // surface something
                break;
            case "mtllib":  // use a different material file - probably won't be supporting
                break;
            case "g":   // group
                break;
            case "o":   // object name
                break;
            case "l":   // line
                break;
            case "#":   // comment
                break;
            default:
                // @gml update try-catch
                show_message("Unsupported thing found in your model, skipping everything (line " + string(line_number) + ")");
                illegal = true;
                break;
        }
        
        ds_queue_destroy(q);
    }
    file_text_close(f);
    
    ds_list_destroy(v_x);
    ds_list_destroy(v_y);
    ds_list_destroy(v_z);
    ds_list_destroy(v_nx);
    ds_list_destroy(v_ny);
    ds_list_destroy(v_nz);
    ds_list_destroy(v_xtex);
    ds_list_destroy(v_ytex);

    ds_map_destroy(mtl_alpha);
    ds_map_destroy(mtl_color_r);
    ds_map_destroy(mtl_color_g);
    ds_map_destroy(mtl_color_b);
    
    if (!illegal) {
        var n = ds_list_size(temp_vertices);
        
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
        
        var bxx = [0, 0, 0];
        var byy = [0, 0, 0];
        var bzz = [0, 0, 0];
        var bnx, bny, bnz, bxtex, bytex, bcolor, balpha;
        
        var minx = 0;
        var miny = 0;
        var minz = 0;
        var maxx = 0;
        var maxy = 0;
        var maxz = 0;
        
        for (var i = 0; i < n; i++) {
            var v = temp_vertices[| i];
            
            bxx[vc] = v[0];
            byy[vc] = v[1];
            bzz[vc] = v[2];
            
            bnx = v[3];
            bny = v[4];
            bnz = v[5];
            
            if (adjust) {
                bxtex = v[6] * TILESET_TEXTURE_WIDTH;
                bytex = v[7] * TILESET_TEXTURE_HEIGHT;
            }
            
            // the texture pages are 4k, so this is four pixels squared
            xtex = round_ext(xtex, 1 / 1024);
            ytex = round_ext(ytex, 1 / 1024);
            
            bcolor = v[8];
            balpha = v[9];
            
            minx = min(minx, v[0]);
            miny = min(miny, v[1]);
            minz = min(minz, v[2]);
            maxx = max(maxx, v[0]);
            maxy = max(maxy, v[1]);
            maxz = max(maxz, v[2]);
            
            vertex_point_complete(vbuffer, bxx[vc], byy[vc], bzz[vc], bnx, bny, bnz, bxtex, bytex, bcolor, balpha);
            
            data_added = true;
            vc = (++vc) % 3;
            
            if (everything && vc == 0) {
                vertex_point_line(wbuffer, bxx[0], byy[0], bzz[0], c_white, 1);
                vertex_point_line(wbuffer, bxx[1], byy[1], bzz[1], c_white, 1);
                
                vertex_point_line(wbuffer, bxx[1], byy[1], bzz[1], c_white, 1);
                vertex_point_line(wbuffer, bxx[2], byy[2], bzz[2], c_white, 1);
                
                vertex_point_line(wbuffer, bxx[2], byy[2], bzz[2], c_white, 1);
                vertex_point_line(wbuffer, bxx[0], byy[0], bzz[0], c_white, 1);
                
                c_shape_add_triangle(bxx[0], byy[0], bzz[0], bxx[1], byy[1], bzz[1], bxx[2], byy[2], bzz[2]);
            }
        }
        
        vertex_end(vbuffer);
        
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
            
            var mesh = instance_create_depth(0, 0, 0, DataMesh);
            
            mesh.xmin = round(minx / IMPORT_GRID_SIZE);
            mesh.ymin = round(miny / IMPORT_GRID_SIZE);
            mesh.zmin = round(minz / IMPORT_GRID_SIZE);
            mesh.xmax = round(maxx / IMPORT_GRID_SIZE);
            mesh.ymax = round(maxy / IMPORT_GRID_SIZE);
            mesh.zmax = round(maxz / IMPORT_GRID_SIZE);
            
            data_mesh_recalculate_bounds(mesh);
            
            var base_name = filename_change_ext(filename_name(fn), "");
            mesh.name = base_name;
            internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
            
            if (data_added) {
                proto_guid_set(mesh, ds_list_size(mesh.buffers));
                ds_list_add(mesh.buffers, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1));
                ds_list_add(mesh.vbuffers, vbuffer);
                ds_list_add(mesh.wbuffers, wbuffer);
                if (!mesh.cshape) {
                    mesh.cshape = cshape;
                } else {
                    c_shape_destroy(cshape);
                }
                
                vertex_freeze(wbuffer);
            }
        }
        
        if (data_added) {
            vertex_freeze(vbuffer);
        }
    }
    
    ds_list_destroy(temp_vertices);
}

return everything ? mesh : vbuffer;