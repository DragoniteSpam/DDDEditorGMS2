/// @param filename
/// @param [complete-object?]
/// @param [raw-buffer?]
/// @param [existing-object]
/// @param [replace-index]
function import_obj() {
    var fn = argument[0];
    // setting "everything" to false will mean only the vertex buffer is returned
    var everything = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
    var raw_buffer = (argument_count > 2 && argument[2] != undefined) ? argument[2] : false;
    var existing = (argument_count > 3 && argument[3] != undefined) ? argument[3] : noone;
    var replace_index = (argument_count > 4 && argument[4] != undefined) ? argument[4] : -1;
    var err = "";
    var warnings = 0;
    
    var warn_map_1 =            0x0001;
    var warn_map_2 =            0x0002;
    var warn_map_3 =            0x0004;
    var warn_map_4 =            0x0008;
    var warn_map_5 =            0x0010;
    var warn_map_6 =            0x0020;
    var warn_map_7 =            0x0040;
    var warn_map_8 =            0x0080;
    var warn_alt_bump =         0x0100;
    
    var base_path = filename_path(fn);
    var base_name = filename_change_ext(filename_name(fn), "");
    
    if (!file_exists(fn)) return noone;
    
    var base_mtl = undefined;
    var active_mtl = -1;
    var mtl_alpha = { };
    var mtl_color_r = { };
    var mtl_color_g = { };
    var mtl_color_b = { };
    var mtl_map_diffuse = { };
    var mtl_map_ambient = { };
    var mtl_map_specular_color = { };
    var mtl_map_specular_highlight = { };
    var mtl_map_alpha = { };
    var mtl_map_bump = { };
    var mtl_map_displace = { };
    var mtl_map_decal = { };
    mtl_alpha[$ active_mtl] = 1;
    mtl_color_r[$ active_mtl] = 255;
    mtl_color_g[$ active_mtl] = 255;
    mtl_color_b[$ active_mtl] = 255;
    
    var tex_base = undefined;
    var tex_ambient = undefined;
    var tex_specular_color = undefined;
    var tex_specular_highlight = undefined;
    var tex_alpha = undefined;
    var tex_bump = undefined;
    var tex_displace = undefined;
    var tex_decal = undefined;
    
    var f = file_text_open_read(fn);
    var line_number = 0;
    
    static v_x = ds_list_create();
    static v_y = ds_list_create();
    static v_z = ds_list_create();
    static v_nx = ds_list_create();
    static v_ny = ds_list_create();
    static v_nz = ds_list_create();
    static v_xtex = ds_list_create();
    static v_ytex = ds_list_create();
    ds_list_clear(v_x);
    ds_list_clear(v_y);
    ds_list_clear(v_z);
    ds_list_clear(v_nx);
    ds_list_clear(v_ny);
    ds_list_clear(v_nz);
    ds_list_clear(v_xtex);
    ds_list_clear(v_ytex);
    
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
    
    static temp_vertices = ds_list_create();
    ds_list_clear(temp_vertices);
    var first_line_read = false;
    var is_blender = false;
    
    #region parse the obj file
    while (!file_text_eof(f) && err == "") {
        line_number++;
        var str = string_strip(file_text_read_string(f));
        
        if (!first_line_read) {
            is_blender = (string_count("Blender", str) > 0);
            first_line_read = true;
        }
        var q = split(str, " ", false, false);
        file_text_readln(f);
        
        if (ds_queue_size(q) == 0) {
            ds_queue_destroy(q);
            continue;
        }
        
        var word = ds_queue_dequeue(q);
        // comments don't have to be single characters
        if (string_char_at(word, 1) != "#") {
            switch (word) {
                case "v":
                    if (ds_queue_size(q) >= 3) {
                        ds_list_add(v_x, real(ds_queue_dequeue(q)));
                        ds_list_add(v_y, real(ds_queue_dequeue(q)));
                        ds_list_add(v_z, real(ds_queue_dequeue(q)));
                    } else {
                        err = "Malformed vertex found (line " + string(line_number) + ")";
                    }
                    break;
                case "vt":
                    if (ds_queue_size(q) >= 2) {
                        ds_list_add(v_xtex, real(ds_queue_dequeue(q)));
                        ds_list_add(v_ytex, real(ds_queue_dequeue(q)));
                    } else {
                        err = "Malformed vertex texture found (line " + string(line_number) + ")";
                    }
                    break;
                case "vn":
                    if (ds_queue_size(q) >= 3) {
                        ds_list_add(v_nx, real(ds_queue_dequeue(q)));
                        ds_list_add(v_ny, real(ds_queue_dequeue(q)));
                        ds_list_add(v_nz, real(ds_queue_dequeue(q)));
                    } else {
                        err = "Malformed vertex normal found (line " + string(line_number) + ")";
                    }
                    break;
                case "usemtl":
                    active_mtl = ds_queue_dequeue(q);
                    break;
                case "f":
                    #region face data
                    if (ds_queue_size(q) >= 3) {
                        xx = [0, 0, 0];
                        yy = [0, 0, 0];
                        zz = [0, 0, 0];
                        nx = [0, 0, 0];
                        nx = [0, 0, 0];
                        nx = [0, 0, 0];
                        xtex = [0, 0, 0];
                        ytex = [0, 0, 0];
                        r = [0, 0, 0];
                        g = [0, 0, 0];
                        b = [0, 0, 0];
                        a = [0, 0, 0];
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
                                    nz[i] = 1;
                                    xtex[i] = 0;
                                    ytex[i] = 0;
                                    r[i] = (mtl_color_r[$ active_mtl] != undefined) ? mtl_color_r[$ active_mtl] : 255;
                                    g[i] = (mtl_color_g[$ active_mtl] != undefined) ? mtl_color_g[$ active_mtl] : 255;
                                    b[i] = (mtl_color_b[$ active_mtl] != undefined) ? mtl_color_b[$ active_mtl] : 255;
                                    a[i] = (mtl_alpha[$ active_mtl] != undefined) ? mtl_alpha[$ active_mtl] : 1;
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
                                    nz[i] = 1;
                                    r[i] = (mtl_color_r[$ active_mtl] != undefined) ? mtl_color_r[$ active_mtl] : 255;
                                    g[i] = (mtl_color_g[$ active_mtl] != undefined) ? mtl_color_g[$ active_mtl] : 255;
                                    b[i] = (mtl_color_b[$ active_mtl] != undefined) ? mtl_color_b[$ active_mtl] : 255;
                                    a[i] = (mtl_alpha[$ active_mtl] != undefined) ? mtl_alpha[$ active_mtl] : 1;
                                    break;
                                case 3:
                                    var vert = real(ds_queue_dequeue(vertex_q)) - 1;
                                    // if the vt term is blank (v//vn), that is
                                    // not the same as having just two terms (v/vt)
                                    var middle_term = ds_queue_dequeue(vertex_q);
                                    var tex = (middle_term == "") ? -1 : (real(middle_term) - 1);
                                    var normal = real(ds_queue_dequeue(vertex_q))-1;
                                    xx[i] = v_x[| vert];
                                    yy[i] = v_y[| vert];
                                    zz[i] = v_z[| vert];
                                    nx[i] = v_nx[| normal];
                                    ny[i] = v_ny[| normal];
                                    nz[i] = v_nz[| normal];
                                    if (tex == -1) {
                                        xtex[i] = 0;
                                        ytex[i] = 0;
                                    } else {
                                        xtex[i] = v_xtex[| tex];
                                        ytex[i] = v_ytex[| tex];
                                    }
                                    r[i] = (mtl_color_r[$ active_mtl] != undefined) ? mtl_color_r[$ active_mtl] : 255;
                                    g[i] = (mtl_color_g[$ active_mtl] != undefined) ? mtl_color_g[$ active_mtl] : 255;
                                    b[i] = (mtl_color_b[$ active_mtl] != undefined) ? mtl_color_b[$ active_mtl] : 255;
                                    a[i] = (mtl_alpha[$ active_mtl] != undefined) ? mtl_alpha[$ active_mtl] : 1;
                                    break;
                            }
                        }
                        // faces are triangle fans
                        for (var i = 2; i < array_length(xx); i++) {
                            ds_list_add(temp_vertices, [xx[0],      yy[0],      zz[0],      nx[0],      ny[0],      nz[0],      xtex[0],        ytex[0],        (b[0] << 16) |      (g[0] << 8) |       r[0],       a[0], active_mtl]);
                            ds_list_add(temp_vertices, [xx[i - 1],  yy[i - 1],  zz[i - 1],  nx[i - 1],  ny[i - 1],  nz[i - 1],  xtex[i - 1],    ytex[i - 1],    (b[i - 1] << 16) |  (g[i - 1] << 8) |   r[i - 1],   a[i - 1], active_mtl]);
                            ds_list_add(temp_vertices, [xx[i - 0],  yy[i - 0],  zz[i - 0],  nx[i - 0],  ny[i - 0],  nz[i - 0],  xtex[i - 0],    ytex[i - 0],    (b[i - 0] << 16) |  (g[i - 0] << 8) |   r[i - 0],   a[i - 0], active_mtl]);
                        }
                        ds_queue_destroy(vertex_q);
                    } else {
                        err = "Malformed face found (line " + string(line_number) + ")";
                    }
                    #endregion
                    break;
                case "s":   // surface shading
                    break;
                case "mtllib":  // specify the mtllib file
                    #region mtl data
                    var mfn = "";
                    while (!ds_queue_empty(q)) mfn += ds_queue_dequeue(q) + (ds_queue_empty(q) ? "" : " ");
                    if (!file_exists(mfn)) mfn = base_path + mfn;
                    
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
                                    mtl_color_r[$ mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                                    mtl_color_g[$ mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                                    mtl_color_b[$ mtl_name] = real(ds_queue_dequeue(spl)) * 255;
                                    break;
                                case "d":   // "dissolved" (alpha)
                                    mtl_alpha[$ mtl_name] = real(ds_queue_dequeue(spl));
                                    break;
                                case "Tr":  // "transparent" (1 - alpha)
                                    mtl_alpha[$ mtl_name] = 1 - real(ds_queue_dequeue(spl));
                                    break;
                                case "map_Kd":                  // dissolve (base) texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".BaseTexture";
                                    if (tex_base) warnings |= warn_map_1;
                                    else mtl_map_diffuse[$ mtl_name] = ts;
                                    tex_base = (tex_base) ? tex_base : ts;
                                    break;
                                case "map_Ka":                  // ambient texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".AmbientMap";
                                    if (tex_ambient) warnings |= warn_map_2;
                                    else mtl_map_ambient[$ mtl_name] = ts;
                                    tex_ambient = (tex_ambient) ? tex_ambient : ts;
                                    break;
                                case "map_Ks":                  // specular color texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".SpecularColorMap";
                                    if (tex_specular_color) warnings |= warn_map_3;
                                    else mtl_map_specular_color[$ mtl_name] = ts;
                                    tex_specular_color = (tex_specular_color) ? tex_specular_color : ts;
                                    break;
                                case "map_Ns":                  // specular highlight texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".SpecularHighlightMap";
                                    if (tex_specular_highlight) warnings |= warn_map_4;
                                    else mtl_map_specular_highlight[$ mtl_name] = ts;
                                    tex_specular_highlight = (tex_specular_highlight) ? tex_specular_highlight : ts;
                                    break;
                                case "map_d":                   // alpha texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".AlphaMap";
                                    if (tex_alpha) warnings |= warn_map_5;
                                    else mtl_map_alpha[$ mtl_name] = ts;
                                    tex_alpha = (tex_alpha) ? tex_alpha : ts;
                                    break;
                                case "map_bump":                // bump texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".BumpMap";
                                    if (tex_bump) warnings |= warn_map_6;
                                    else mtl_map_bump[$ mtl_name] = ts;
                                    tex_bump = (tex_bump) ? tex_bump : ts;
                                    break;
                                case "bump":
                                    warnings |= warn_alt_bump;
                                    break;
                                case "disp":                    // displacement texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".DisplacementMap";
                                    if (tex_displace) warnings |= warn_map_7;
                                    else mtl_map_displace[$ mtl_name] = ts;
                                    tex_displace = (tex_displace) ? tex_displace : ts;
                                    break;
                                case "decal":                   // stencil decal texture
                                    var texfn = "";
                                    while (!ds_queue_empty(spl)) texfn += ds_queue_dequeue(spl) + (ds_queue_empty(spl) ? "" : " ");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    var ts = tileset_create(texfn, undefined);
                                    ts.name = base_name + ".StencilDecal";
                                    if (tex_decal) warnings |= warn_map_8;
                                    else mtl_map_decal[$ mtl_name] = ts;
                                    tex_decal = (tex_decal) ? tex_decal : ts;
                                    break;
                                default:    // There are way more attributes available than I'm going to use later - maybe
                                    break;
                            }
                            ds_queue_destroy(spl);
                        }
                        file_text_close(matfile);
                    }
                    #endregion
                    break;
                case "g":   // group
                    break;
                case "o":   // object name
                    break;
                case "l":   // line
                    break;
                default:
                    err = "Unsupported thing found in your model, skipping everything (line " + string(line_number) + "): " + string(word);
                    break;
            }
        }
        ds_queue_destroy(q);
    }
    file_text_close(f);
    #endregion
    
    if (warnings) {
        var warn_header = "Warnings generated regarding the imported mesh:\n";
        var warn_header_plural = "Warnings generated regarding the a number of the imported meshes:\n";
        var top = ds_list_top(Stuff.dialogs);
        if (!top || !(top.dialog_flags & DialogFlags.IS_GENERIC_WARNING)) {
            var warn_string = "";
            if (warnings & warn_map_1) warn_string += "Tried to load more than one diffuse texture map (map_Kd) - this is not yet supported\n";
            if (warnings & warn_map_2) warn_string += "Tried to load more than one ambient texture map (map_Ka) - this is not yet supported\n";
            if (warnings & warn_map_3) warn_string += "Tried to load more than one specular color texture map (map_Ks) - this is not yet supported\n";
            if (warnings & warn_map_4) warn_string += "Tried to load more than one specular highlight texture map (map_Ns) - this is not yet supported\n";
            if (warnings & warn_map_5) warn_string += "Tried to load more than one alpha texture map (map_Ka) - this is not yet supported\n";
            if (warnings & warn_map_6) warn_string += "Tried to load more than one bump map (map_bump) - this is not yet supported\n";
            if (warnings & warn_map_7) warn_string += "Tried to load more than one displacement texture map (disp) - this is not yet supported\n";
            if (warnings & warn_map_8) warn_string += "Tried to load more than one stencil decal texture map (decal) - this is not yet supported\n";
            if (warnings & warn_alt_bump) warn_string += "Alternate bump map material data found - this is not yet supported\n";
            (dialog_create_notice(noone, warn_header + warn_string)).dialog_flags |= DialogFlags.IS_GENERIC_WARNING;
        } else {
            top.el_text.text = string_replace(top.el_text.text, warn_header, warn_header_plural);
        }
    }
    
    if (err != "") {
        dialog_create_notice(noone, "Could not load the model: " + err);
        return noone;
    }
    
    var n = ds_list_size(temp_vertices);
    
    var vbuffers = { };
    var wbuffers = { };
    var cshape = c_shape_create();
    
    var vc = 0;
    
    var bxx = [0, 0, 0];
    var byy = [0, 0, 0];
    var bzz = [0, 0, 0];
    var bnx, bny, bnz, bxtex, bytex, bcolor, balpha, bmtl;
    
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
        
        if (is_blender) {
            v[7] = 1 - v[7];
        }
        
        bxtex = v[6];
        bytex = v[7];
        
        // the texture pages are 2k, so this is two pixels squared
        bxtex = round_ext(bxtex, 1 / 1024);
        bytex = round_ext(bytex, 1 / 1024);
        
        bcolor = v[8];
        balpha = v[9];
        bmtl = v[10];
        
        if (base_mtl == undefined) base_mtl = bmtl;
        
        minx = min(minx, v[0]);
        miny = min(miny, v[1]);
        minz = min(minz, v[2]);
        maxx = max(maxx, v[0]);
        maxy = max(maxy, v[1]);
        maxz = max(maxz, v[2]);
        
        if (!vbuffers[$ bmtl]) {
            vbuffers[$ bmtl] = vertex_create_buffer();
            wbuffers[$ bmtl] = vertex_create_buffer();
            vertex_begin(vbuffers[$ bmtl], Stuff.graphics.vertex_format);
            if (everything) {
                vertex_begin(wbuffers[$ bmtl], Stuff.graphics.vertex_format);
                c_shape_begin_trimesh();
            }
        }
        
        var vb = vbuffers[$ bmtl];
        var wb = wbuffers[$ bmtl];
        
        vertex_point_complete(vb, bxx[vc], byy[vc], bzz[vc], bnx, bny, bnz, bxtex, bytex, bcolor, balpha);
        
        vc = (++vc) % 3;
        
        if (everything && vc == 0) {
            vertex_point_line(wb, bxx[0], byy[0], bzz[0], c_white, 1);
            vertex_point_line(wb, bxx[1], byy[1], bzz[1], c_white, 1);
            vertex_point_line(wb, bxx[1], byy[1], bzz[1], c_white, 1);
            vertex_point_line(wb, bxx[2], byy[2], bzz[2], c_white, 1);
            vertex_point_line(wb, bxx[2], byy[2], bzz[2], c_white, 1);
            vertex_point_line(wb, bxx[0], byy[0], bzz[0], c_white, 1);
            
            if (bmtl == base_mtl) {
                c_shape_add_triangle(bxx[0], byy[0], bzz[0], bxx[1], byy[1], bzz[1], bxx[2], byy[2], bzz[2]);
            }
        }
    }
    
    ds_list_destroy(temp_vertices);
    
    var vb_base = vbuffers[$ base_mtl];
    var wb_base = wbuffers[$ base_mtl];
    
    vertex_end(vb_base);
    vertex_end(wb_base);
    
    variable_struct_remove(vbuffers, base_mtl);
    variable_struct_remove(wbuffers, base_mtl);
    var vbuffer_materials = variable_struct_get_names(vbuffers);
    
    for (var i = 0; i < array_length(vbuffer_materials); i++) {
        var mat = vbuffer_materials[i];
        if (vertex_get_number(vbuffers[$ mat]) == 0) {
            vertex_delete_buffer(vbuffers[$ mat]);
            vertex_delete_buffer(wbuffers[$ mat]);
            variable_struct_remove(vbuffers, mat);
            variable_struct_remove(wbuffers, mat);
        } else {
            vertex_end(vbuffers[$ mat]);
            vertex_end(wbuffers[$ mat]);
        }
    }
    
    c_shape_destroy(cshape);
    
    if (everything) {
        var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
        
        if (!existing) {
            mesh.xmin = round(minx / IMPORT_GRID_SIZE);
            mesh.ymin = round(miny / IMPORT_GRID_SIZE);
            mesh.zmin = round(minz / IMPORT_GRID_SIZE);
            mesh.xmax = round(maxx / IMPORT_GRID_SIZE);
            mesh.ymax = round(maxy / IMPORT_GRID_SIZE);
            mesh.zmax = round(maxz / IMPORT_GRID_SIZE);
            
            data_mesh_recalculate_bounds(mesh);
            mesh.name = base_name;
            internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
        }
        
        if (vertex_get_number(vb_base) > 0) {
            mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vb_base, buffer_fixed, 1), vb_base, wb_base, undefined, base_name + "." + string(base_mtl), -1, fn);
            if (mesh.cshape) {
                c_shape_destroy(cshape);
            } else {
                mesh.cshape = cshape;
            }
        }
        
        //This is untested and will probably break in a lot of places
        var vbuffer_materials = variable_struct_get_names(vbuffers);
        for (var i = 0; i < array_length(vbuffer_materials); i++) {
            var mat = vbuffer_materials[i];
            mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffers[$ mat], buffer_fixed, 1), vbuffers[$ mat], wbuffers[$ mat], undefined, base_name + "." + mat, -1, fn);
        }
        
        // assign these based on the material lookup eventually
        mesh.tex_base = tex_base ? tex_base.GUID : NULL;
        mesh.tex_ambient = tex_ambient ? tex_ambient.GUID : NULL;
        mesh.tex_specular_color = tex_specular_color ? tex_specular_color.GUID : NULL;
        mesh.tex_specular_highlight = tex_specular_highlight ? tex_specular_highlight.GUID : NULL;
        mesh.tex_alpha = tex_alpha ? tex_alpha.GUID : NULL;
        mesh.tex_bump = tex_bump ? tex_bump.GUID : NULL;
        mesh.tex_displacement = tex_displace ? tex_displace.GUID : NULL;
        mesh.tex_stencil = tex_decal ? tex_decal.GUID : NULL;
        
        return mesh;
    }
    
    c_shape_destroy(cshape);
    
    if (vertex_get_number(vb_base) > 0) {
        vertex_freeze(vb_base);
        return vb_base;
    }
    
    vertex_delete_buffer(vb_base);
    
    return noone;
}