function MeshImportData(buffer, material) constructor {
    self.buffer = buffer;
    self.material = material;
}

function import_mesh(filename) {
    var data = import_3d_model_generic(filename);
    if (data == undefined) return undefined;
    
    var mesh = new DataMesh(filename_change_ext(filename_name(filename), ""));
    for (var i = 0, n = array_length(data); i < n; i++) {
        var submesh = new MeshSubmesh(data[i].material.name);
        submesh.path = filename;
        submesh.SetBufferData(data[i].buffer);
        if (array_length(data) >= 1) {
            submesh.SetMaterial(data[i].material);
        }
        mesh.AddSubmesh(submesh);
    }
    
    array_push(Game.meshes, mesh);
    Stuff.mesh.ui.GetChild("MESH LIST").Select(array_length(Game.meshes) - 1, true);
    
    return mesh;
}

function import_3d_model_generic(filename, squash = false) {
    /// @todo more robust try-catch
    try {
        switch (filename_ext(filename)) {
            case ".mtl": return import_obj(filename_change_ext(filename, ".obj"), squash);
            case ".obj": return import_obj(filename, squash);
            case ".d3d": case ".gmmod": return import_d3d(filename);
            case ".smf": return undefined;
            
            case ".fbx": case ".3ds": case ".dae": case ".gltf": case ".glb": case ".ply": case ".plyb":
                return import_mesh_exotic(filename);
        }
    } catch (e) {
        Stuff.AddStatusMessage("Could not load the file: [c_orange]" + e.message);
        show_debug_message(json_stringify(e, true));
    }
    return undefined;
}

function import_mesh_exotic(filename) {
    if (!directory_exists(PATH_ASSIMP_CONVERSION)) directory_create(PATH_ASSIMP_CONVERSION);
    
    var temp_filename = $"{PROJECT_PATH_ROOT}{PATH_ASSIMP_CONVERSION}/{md5_string_unicode(filename)}.obj";
    var temp_filename_mtl = $"{PROJECT_PATH_ROOT}{PATH_ASSIMP_CONVERSION}/{md5_string_unicode(filename)}.mtl";
    assops_convert_obj(filename, temp_filename);
    
    if (!file_exists(temp_filename)) {
        // because of pop-up reasons this needs to happen after the files load
        call_later(1, time_source_units_frames, method({ filename }, function() {
            Stuff.AddErrorMessage($"Could not load [c_aqua]{filename_name(filename)}[/c] for some reason");
        }));
        return undefined;
    }
    
    var obj = import_obj(temp_filename);
    file_delete(temp_filename);
    file_delete(temp_filename_mtl);
    return obj;
}

function import_d3d(filename) {
    var f = file_text_open_read(filename);
    file_text_readln(f);
    var n = file_text_read_real(f) - 2;
    file_text_readln(f);
    
    var data = buffer_create(1000, buffer_grow, 1);
    
    var vc = 0;
    
    var xx = [0, 0, 0];
    var yy = [0, 0, 0];
    var zz = [0, 0, 0];
    
    var nx = [0, 0, 0];
    var ny = [0, 0, 0];
    var nz = [0, 0, 0];
    var xtex = [0, 0, 0];
    var ytex = [0, 0, 0];
    var color = [0, 0, 0];
    var alpha = [0, 0, 0];
    
    #macro tri_type_list 4
    #macro tri_type_strip 5
    #macro tri_type_fan 6
    var tri_type = tri_type_list;
    
    #region big fat loop
    while (!file_text_eof(f)) {
        var type = file_text_read_real(f);
        
        switch (type) {
            case 0: tri_type = file_text_read_real(f); file_text_readln(f); continue;
            case 1:
                file_text_readln(f);
                vc = 0;
                xx = [0, 0, 0]; yy = [0, 0, 0]; zz = [0, 0, 0];
                nx = [0, 0, 0]; ny = [0, 0, 0]; nz = [0, 0, 0];
                xtex = [0, 0, 0]; ytex = [0, 0, 0];
                color = [0, 0, 0]; alpha = [0, 0, 0];
                continue;
            case 2: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 3: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 4: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 5: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 6: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 7: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 8: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); file_text_readln(f); break;
            case 9: xx[vc] = file_text_read_real(f); yy[vc] = file_text_read_real(f); zz[vc] = file_text_read_real(f); nx[vc] = file_text_read_real(f); ny[vc] = file_text_read_real(f); nz[vc] = file_text_read_real(f); xtex[vc] = file_text_read_real(f); ytex[vc] = file_text_read_real(f); color[vc] = file_text_read_real(f); alpha[vc] = file_text_read_real(f); file_text_readln(f); break;
            default: wtf("Unsupported structure in " + filename + ", skipping. Please convert your primitive shapes into triangles. Thank."); file_text_readln(f); continue;
        }
        
        // the texture pages are 4k, so this is four pixels squared
        xtex[vc] = round_ext(xtex[vc], 1 / 1024);
        ytex[vc] = round_ext(ytex[vc], 1 / 1024);
        
        vc++;
        
        if (vc == 3) {
            vertex_point_complete_raw(data, xx[0], yy[0], zz[0], nx[0], ny[0], nz[0], xtex[0], ytex[0], color[0], alpha[0]);
            vertex_point_complete_raw(data, xx[1], yy[1], zz[1], nx[1], ny[1], nz[1], xtex[1], ytex[1], color[1], alpha[1]);
            vertex_point_complete_raw(data, xx[2], yy[2], zz[2], nx[2], ny[2], nz[2], xtex[2], ytex[2], color[2], alpha[2]);
            
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
    
    buffer_resize(data, buffer_tell(data));
    
    // this function needs to return an array of MeshImportData, even though
    // there will only ever be one buffer loaded from a d3d file
    return [new MeshImportData(data, new Material(filename_name(filename_change_ext(filename, "")) + "_Material"))];
}

function import_obj(fn, squash = false) {
    static warn_invisible = false;
    
    var base_path = filename_path(fn);
    var base_name = filename_change_ext(filename_name(fn), "");
    
    if (!file_exists(fn)) return undefined;
    var materials = { };
    var material_cache = { };                                   // if you try to load in a bunch of files at once that all use the same mtl, you only need to parse the file once
    var active_material = new Material(base_name + "_BaseMaterial");
    var base_material = active_material;
    
    var buffer = buffer_load(fn);
    var lines = string_split(buffer_read(buffer, buffer_text), "\n", true);
    buffer_delete(buffer);
    
    static buffer_attribute_type = buffer_f32;
    static color_attribute_type = buffer_u32;
    static buffer_attribute_size = buffer_sizeof(buffer_attribute_type);
    static color_attribute_size = buffer_sizeof(color_attribute_type);
    
    static v_x = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_y = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_z = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_nx = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_ny = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_nz = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_xtex = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_ytex = buffer_create(1000, buffer_grow, buffer_attribute_size);
    static v_color = buffer_create(1000, buffer_grow, buffer_attribute_size);
    buffer_seek(v_x, buffer_seek_start, 0);
    buffer_seek(v_y, buffer_seek_start, 0);
    buffer_seek(v_z, buffer_seek_start, 0);
    buffer_seek(v_nx, buffer_seek_start, 0);
    buffer_seek(v_ny, buffer_seek_start, 0);
    buffer_seek(v_nz, buffer_seek_start, 0);
    buffer_seek(v_xtex, buffer_seek_start, 0);
    buffer_seek(v_ytex, buffer_seek_start, 0);
    buffer_seek(v_color, buffer_seek_start, 0);
    
    static face_attribute_type = buffer_f32;
    
    static face_vertex_attributes = buffer_create(1000, buffer_grow, buffer_sizeof(face_attribute_type));
    static face_vertex_materials = ds_list_create();
    buffer_seek(face_vertex_attributes, buffer_seek_start, 0);
    ds_list_clear(face_vertex_materials);
    
    static xx = [0, 0, 0];
    static yy = [0, 0, 0];
    static zz = [0, 0, 0];
    static nx = [0, 0, 0];
    static ny = [0, 0, 0];
    static nz = [0, 0, 0];
    static xtex = [0, 0, 0];
    static ytex = [0, 0, 0];
    static color = [0, 0, 0];
    
    var first_line_read = false;
    var needs_uvs_flipped = false;
    
    #region parse the obj file
    for (var line_index = 0, line_count = array_length(lines); line_index < line_count; line_index++) {
        var str = string_trim(lines[line_index]);
        if (str == "") continue;
        
        if (!first_line_read) {
            needs_uvs_flipped = (string_count("Blender", str) > 0);
            needs_uvs_flipped |= (string_count("Blockbench", str) > 0);
            first_line_read = true;
        }
        var line = string_split(str, " ", true);
        
        if (!string_starts_with(line[0], "#")) {
            switch (line[0]) {
                case "v":
                    buffer_write(v_x, buffer_attribute_type, real(line[1]));
                    buffer_write(v_y, buffer_attribute_type, real(line[2]));
                    buffer_write(v_z, buffer_attribute_type, real(line[3]));
                    // the unofficial "vertex color" spec involves sticking
                    // three rgb color values after the position
                    if (array_length(line) > 4) {
                        buffer_write(v_color, color_attribute_type, 0xff000000 | make_colour_rgb(floor(real(line[4])), floor(real(line[5])), floor(real(line[6]))));
                    } else {
                        buffer_write(v_color, color_attribute_type, 0xffffffff);
                    }
                    break;
                case "vt":
                    buffer_write(v_xtex, buffer_attribute_type, real(line[1]));
                    buffer_write(v_ytex, buffer_attribute_type, real(line[2]));
                    break;
                case "vn":
                    buffer_write(v_nx, buffer_attribute_type, real(line[1]));
                    buffer_write(v_ny, buffer_attribute_type, real(line[2]));
                    buffer_write(v_nz, buffer_attribute_type, real(line[3]));
                    break;
                case "usemtl":
                    array_shift(line);
                    active_material = materials[$ array_join(line)] ?? base_material;
                    break;
                case "usemap":
                    // this would specifically fetch a texture map but i'd
                    // rather not support it if i dont have to
                    break;
                case "f":
                    #region face data
                    array_shift(line);
                    var s = array_length(line);
                    for (var i = 0; i < s; i++) {
                        var vertex_tokens = string_split(line[i], "/", false);
                        switch (array_length(vertex_tokens)) {
                            case 1:
                                var vert = real(vertex_tokens[0]) - 1;    // each of these are -1 because they start indexing from 1 instead of 0. Why? because the obj file format sucks.
                                xx[i] = buffer_peek(v_x, buffer_attribute_size * vert, buffer_attribute_type);
                                yy[i] = buffer_peek(v_y, buffer_attribute_size * vert, buffer_attribute_type);
                                zz[i] = buffer_peek(v_z, buffer_attribute_size * vert, buffer_attribute_type);
                                nx[i] = 0;
                                ny[i] = 0;
                                nz[i] = 1;
                                xtex[i] = 0;
                                ytex[i] = 0;
                                color[i] = buffer_peek(v_color, color_attribute_size * vert, color_attribute_type);
                                break;
                            case 2:
                                var vert = real(vertex_tokens[0]) - 1;
                                var tex = real(vertex_tokens[1]) - 1;
                                xx[i] = buffer_peek(v_x, buffer_attribute_size * vert, buffer_attribute_type);
                                yy[i] = buffer_peek(v_y, buffer_attribute_size * vert, buffer_attribute_type);
                                zz[i] = buffer_peek(v_z, buffer_attribute_size * vert, buffer_attribute_type);
                                xtex[i] = buffer_peek(v_xtex, buffer_attribute_size * tex, buffer_attribute_type);
                                ytex[i] = buffer_peek(v_ytex, buffer_attribute_size * tex, buffer_attribute_type);
                                nx[i] = 0;
                                ny[i] = 0;
                                nz[i] = 1;
                                color[i] = buffer_peek(v_color, color_attribute_size * vert, color_attribute_type);
                                break;
                            case 3:
                                var vert = real(vertex_tokens[0]) - 1;
                                // if the vt term is blank (v//vn), that is
                                // not the same as having just two terms (v/vt)
                                var middle_term = vertex_tokens[1];
                                var tex = (middle_term == "") ? -1 : (real(middle_term) - 1);
                                var normal = real(vertex_tokens[2]) - 1;
                                xx[i] = buffer_peek(v_x, buffer_attribute_size * vert, buffer_attribute_type);
                                yy[i] = buffer_peek(v_y, buffer_attribute_size * vert, buffer_attribute_type);
                                zz[i] = buffer_peek(v_z, buffer_attribute_size * vert, buffer_attribute_type);
                                nx[i] = buffer_peek(v_nx, buffer_attribute_size * normal, buffer_attribute_type);
                                ny[i] = buffer_peek(v_ny, buffer_attribute_size * normal, buffer_attribute_type);
                                nz[i] = buffer_peek(v_nz, buffer_attribute_size * normal, buffer_attribute_type);
                                xtex[i] = (tex == -1) ? 0 : buffer_peek(v_xtex, buffer_attribute_size * tex,  buffer_attribute_type);
                                ytex[i] = (tex == -1) ? 0 : buffer_peek(v_ytex, buffer_attribute_size * tex,  buffer_attribute_type);
                                color[i] = buffer_peek(v_color, color_attribute_size * vert, color_attribute_type);
                                break;
                        }
                    }
                        
                    // faces are triangle fans
                    for (var i = 2; i < s; i++) {
                        buffer_write(face_vertex_attributes, face_attribute_type, xx[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, yy[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, zz[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nx[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ny[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nz[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, xtex[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ytex[0]);
                        buffer_write(face_vertex_attributes, color_attribute_type, color[0]);
                        buffer_write(face_vertex_attributes, face_attribute_type, xx[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, yy[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, zz[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nx[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ny[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nz[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, xtex[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ytex[i - 1]);
                        buffer_write(face_vertex_attributes, color_attribute_type, color[i - 1]);
                        buffer_write(face_vertex_attributes, face_attribute_type, xx[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, yy[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, zz[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nx[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ny[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, nz[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, xtex[i]);
                        buffer_write(face_vertex_attributes, face_attribute_type, ytex[i]);
                        buffer_write(face_vertex_attributes, color_attribute_type, color[i]);
                        ds_list_add(face_vertex_materials, active_material);
                    }
                    #endregion
                    break;
                case "s":   // surface shading
                    break;
                case "mtllib":  // specify the mtllib file
                    #region mtl data
                    array_shift(line);
                    var material_file_name = array_join(line);
                    
                    if (material_cache[$ material_file_name]) {
                        var keys = variable_struct_get_names(material_cache[$ material_file_name]);
                        for (var i = 0, n = array_length(keys); i < n; i++) {
                            materials[$ keys[i]] = material_cache[$ material_file_name][$ keys[i]];
                        }
                        break;
                    }
                    
                    var filename = file_exists(material_file_name) ? material_file_name : (base_path + material_file_name);
                    if (!file_exists(filename)) break;
                    
                    var matfile = file_text_open_read(filename);
                    var current_material = undefined;
                    var from_file = { };
                    material_cache[$ filename] = from_file;
                    self.name = filename_name(filename_change_ext(filename, ""));
                        
                    while (!file_text_eof(matfile)) {
                        var line = file_text_read_string(matfile);
                        file_text_readln(matfile);
                        if (line == "") continue;
                        
                        var material_tokens = string_split(line, " ", true);
                        switch (material_tokens[0]) {
                            case "newmtl":
                                array_shift(material_tokens);
                                var name = array_join(material_tokens);
                                current_material = new Material(name)
                                materials[$ name] = current_material;
                                from_file[$ name] = current_material;
                                break;
                            case "Kd":  // Diffuse color (the color we're concerned with)
                                if (current_material) {
                                    var cr = real(material_tokens[1]) * 255;
                                    var cg = real(material_tokens[2]) * 255;
                                    var cb = real(material_tokens[3]) * 255;
                                    current_material.col_diffuse = make_colour_rgb(cr, cg, cb);
                                }
                                break;
                            case "Ka":  // Ambient color
                                if (current_material) {
                                    var cr = real(material_tokens[1]) * 255;
                                    var cg = real(material_tokens[2]) * 255;
                                    var cb = real(material_tokens[3]) * 255;
                                    current_material.col_ambient = make_colour_rgb(cr, cg, cb);
                                }
                                break;
                            case "Ks":  // Specular color
                                if (current_material) {
                                    var cr = real(material_tokens[1]) * 255;
                                    var cg = real(material_tokens[2]) * 255;
                                    var cb = real(material_tokens[3]) * 255;
                                    current_material.col_specular = make_colour_rgb(cr, cg, cb);
                                }
                                break;
                            case "Ns":  // Specular exponent
                                if (current_material) {
                                    current_material.col_specular_exponent = real(material_tokens[1]);
                                }
                                break;
                            case "d":   // "dissolved" (alpha)
                            case "Tr":
                                if (current_material) {
                                    // why can we never agree on this
                                    if (material_tokens[0] == "Tr" && needs_uvs_flipped) {
                                        current_material.alpha = 1 - real(material_tokens[1]);
                                    } else {
                                        current_material.alpha = real(material_tokens[1]);
                                    }
                                }
                                break;
                            case "map_Kd":                  // dissolve (base) texture
                                if (current_material) {
                                    array_shift(material_tokens)
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_base = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            // there are other PBR attributes but this is the one i care most about now
                            case "map_Kn":                  // normal map texture
                            case "norm":
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_normal = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "map_Ka":                  // ambient texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_ambient = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "map_Ks":                  // specular color texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_specular_color = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "map_Ns":                  // specular highlight texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_specular_highlight = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "map_d":                   // alpha texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_alpha = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "map_bump":                // bump texture
                            case "bump":
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_bump = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "disp":                    // displacement texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_displace = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            case "decal":                   // stencil decal texture
                                if (current_material) {
                                    array_shift(material_tokens);
                                    var texfn = array_join(material_tokens);
                                    texfn = string_replace_all(texfn, "\\\\", "/");
                                    if (!file_exists(texfn)) texfn = base_path + texfn;
                                    if (file_exists(texfn)) {
                                        current_material.tex_decal = tileset_create(texfn, filename_name(texfn)).GUID;
                                    }
                                }
                                break;
                            default:    // There are way more attributes available than I'm going to use later - maybe
                                break;
                        }
                    }
                    
                    file_text_close(matfile);
                    
                    #endregion
                    break;
                case "g":   // group
                    break;
                case "o":   // object name
                    break;
                case "l":   // line
                    break;
            }
        }
    }
    #endregion
    
    var face_count = ds_list_size(face_vertex_materials);
    
    if (face_count == 0) {
        emu_dialog_notice("No face data found in the model " + fn);
        return undefined;
    }
    
    var output_material = base_material;
    var output_data = new MeshImportData(buffer_create(1000, buffer_grow, 1), output_material);
    var output = [output_data];
    
    var max_alpha = 0;
    
    buffer_seek(face_vertex_attributes, buffer_seek_start, 0);
    
    for (var i = 0; i < face_count; i++) {
        var face_material = face_vertex_materials[| i];
        
        // if the material you're working with changes, check to see if any
        // output data with the material already exists; if not, create one
        var current_output_material = face_material;
        if (output_material != current_output_material) {
            output_data = undefined;
            for (var j = 0, n2 = array_length(output); j < n2; j++) {
                if (output[j].material == current_output_material) {
                    output_data = output[j];
                    output_material = current_output_material;
                }
            }
            if (!output_data) {
                output_data = new MeshImportData(buffer_create(1000, buffer_grow, 1), current_output_material);
                array_push(output, output_data);
            }
        }
        
        // always use the vertex color of the current material (for now)
        max_alpha = max(max_alpha, face_material.alpha);
        repeat (3) {
            var vxx = buffer_read(face_vertex_attributes, face_attribute_type);
            var vyy = buffer_read(face_vertex_attributes, face_attribute_type);
            var vzz = buffer_read(face_vertex_attributes, face_attribute_type);
            var vnx = buffer_read(face_vertex_attributes, face_attribute_type);
            var vny = buffer_read(face_vertex_attributes, face_attribute_type);
            var vnz = buffer_read(face_vertex_attributes, face_attribute_type);
            var vxtex = buffer_read(face_vertex_attributes, face_attribute_type);
            var vytex = buffer_read(face_vertex_attributes, face_attribute_type);
            var vcolor = buffer_read(face_vertex_attributes, color_attribute_type)
            vertex_point_complete_raw(output_data.buffer, vxx, vyy, vzz, vnx, vny, vnz, vxtex, needs_uvs_flipped ? (1 - vytex) : vytex, vcolor & 0x00ffffff, (vcolor >> 24) / 0xff);
        }
    }
    
    if (max_alpha < 0.05 && !warn_invisible) {
        emu_dialog_notice("All of the materials in this model have a very low alpha. If this is intentional, you can ignore this message. If this is otherwise due to a quirk of the tool used to create it, you can go into Materials and correct the transparency of each material's diffuse color as needed.");
        warn_invisible = true;
    }
    
    // seek and destroy empty vertex buffers
    for (var i = array_length(output) - 1; i >= 0; i--) {
        var buffer = output[i].buffer;
        if (buffer_tell(buffer) == 0) {
            buffer_delete(buffer);
            array_delete(output, i, 1);
        } else {
            buffer_resize(buffer, buffer_tell(buffer));
        }
    }
    
    if (Settings.mesh.combine_obj_submeshes || squash) {
        // this option will supercede (and include) the next one
        var common_data = buffer_create(0, buffer_fixed, 1);
        for (var i = array_length(output) - 1; i >= 0; i--) {
            var submesh = output[i];
            var tell = buffer_get_size(common_data);
            meshops_blend_color(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), submesh.material.col_diffuse);
            buffer_append_buffer(common_data, submesh.buffer);
            buffer_delete(submesh.buffer);
        }
        
        output = [new MeshImportData(common_data, base_material)];
        base_material.name = "BASE MATERIAL";
    } else if (Settings.mesh.fuse_textureless_materials) {
        // if any material doesn't actually have any textures (eg a mesh that
        // uses only vertex colors), you can fuse them together for free
        var common_data = undefined;
        for (var i = array_length(output) - 1; i >= 0; i--) {
            var submesh = output[i];
            if (!submesh.material.HasAnyTextures()) {
                if (!common_data) {
                    meshops_blend_color(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), submesh.material.col_diffuse);
                    common_data = new MeshImportData(submesh.buffer, new Material("BASE MATERIAL"));
                } else {
                    var tell = buffer_get_size(common_data.buffer);
                    meshops_blend_color(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), submesh.material.col_diffuse);
                    buffer_append_buffer(common_data.buffer, submesh.buffer);
                    buffer_resize(common_data.buffer, buffer_get_size(common_data.buffer) + buffer_get_size(submesh.buffer));
                    buffer_copy(submesh.buffer, 0, buffer_get_size(submesh.buffer), common_data.buffer, tell);
                    buffer_delete(submesh.buffer);
                }
                array_delete(output, i, 1);
            }
        }
        
        if (common_data) {
            array_insert(output, 0, common_data);
        }
    }
    
    if (array_length(output) == 0) return undefined;
    
    return output;
}

function import_texture(fn) {
    // This is specifically for handling texture files dropped onto the UI
    var ts = tileset_create(fn);
    ts.name = filename_change_ext(filename_name(fn),"");
    
    if (!EmuOverlay.GetTop() || !(EmuOverlay.GetTop().flags & DialogFlags.IS_GENERIC_WARNING)) {
        var manager = dialog_create_manager_graphics();
        manager.contents_interactive = true;
        manager.flags |= DialogFlags.IS_GENERIC_WARNING;
        if (manager.SearchID("TYPE")) manager.SearchID("TYPE").value = 0;
        manager.SearchID("LIST").Select(array_length(Game.graphics.tilesets) - 1);
        manager.Refresh({ list: Game.graphics.tilesets, index: array_length(Game.graphics.tilesets) - 1 });
    }
    
    return ts;
}