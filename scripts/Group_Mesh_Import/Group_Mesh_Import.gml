function MeshImportData(buffer, material) constructor {
    self.buffer = buffer;
    self.material = material;
}

function import_mesh(filename) {
    var data = import_3d_model_generic(filename);
    if (data == undefined) return undefined;
    
    var mesh = new DataMesh(filename_change_ext(filename_name(filename), ""));
    for (var i = 0, n = array_length(data); i < n; i++) {
        var submesh = new MeshSubmesh("Submesh" + string(i));
        submesh.SetBufferData(data[i].buffer);
        mesh.AddSubmesh(submesh);
    }
    
    mesh.SetMaterial(data[0].material);
    
    array_push(Game.meshes, mesh);
    
    return mesh;
}

function import_3d_model_generic(filename, squash = false) {
    /// @todo more robust try-catch
    try {
        switch (filename_ext(filename)) {
            case ".obj": return import_obj(filename, squash);
            case ".d3d": case ".gmmod": return import_d3d(filename);
            case ".smf": 
        }
    } catch (e) {
        // ignore
    }
    return undefined;
}

function import_d3d(filename, squash = false) {
    squash |= Settings.config.squash_meshes;
    
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
            default: wtf("Unsupported structure in " + fn + ", skipping. Please convert your primitive shapes into triangles. Thank."); file_text_readln(f); continue;
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

function import_dae(filename, adjust_uvs = true) {
    var container = dotdae_model_load_file(filename, adjust_uvs, false);
    
    var base_name = filename_change_ext(filename_name(filename), "");
    var mesh = new DataMesh(base_name);
    array_push(Game.meshes, mesh);
    
    var geometry = container[eDotDae.GeometryList];
    var mesh_array = geometry[| 0][eDotDaeGeometry.MeshArray];
    var vbuff_array = mesh_array[0][eDotDaeMesh.VertexBufferArray];
    
    for (var i = 0; i < array_length(vbuff_array); i++) {
        var poly_list = vbuff_array[i];
        /// @todo ...
    }
}

function import_obj(fn, everything = true, raw_buffer = false, existing = undefined, replace_index = -1) {
    var err = "";
    static warn_invisible = false;
    
    var base_path = filename_path(fn);
    var base_name = filename_change_ext(filename_name(fn), "");
    
    if (!file_exists(fn)) return undefined;
    var base_mtl = undefined;
    var materials = { };
    var active_material = new Material(base_name + "_BaseMaterial", c_white, 1, , , , MAP_ACTIVE_TILESET.GUID);
    var base_material = active_material;
    
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
                    active_material = materials[$ ds_queue_dequeue(q)] ?? base_material;
                    break;
                case "usemap":
                    // this would specifically fetch a texture map but i'd
                    // rather not support it if i dont have to
                    break;
                case "f":
                    #region face data
                    if (ds_queue_size(q) >= 3) {
                        xx = [0, 0, 0];
                        yy = [0, 0, 0];
                        zz = [0, 0, 0];
                        nx = [0, 0, 0];
                        ny = [0, 0, 0];
                        nz = [0, 0, 0];
                        xtex = [0, 0, 0];
                        ytex = [0, 0, 0];
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
                                    xtex[i] = (tex == -1) ? 0 : v_xtex[| tex];
                                    ytex[i] = (tex == -1) ? 0 : v_ytex[| tex];
                                    break;
                            }
                            ds_queue_destroy(vertex_q);
                        }
                        
                        // faces are triangle fans
                        for (var i = 2; i < array_length(xx); i++) {
                            ds_list_add(temp_vertices, [xx[0],      yy[0],      zz[0],      nx[0],      ny[0],      nz[0],      xtex[0],        ytex[0],        active_material]);
                            ds_list_add(temp_vertices, [xx[i - 1],  yy[i - 1],  zz[i - 1],  nx[i - 1],  ny[i - 1],  nz[i - 1],  xtex[i - 1],    ytex[i - 1],    active_material]);
                            ds_list_add(temp_vertices, [xx[i - 0],  yy[i - 0],  zz[i - 0],  nx[i - 0],  ny[i - 0],  nz[i - 0],  xtex[i - 0],    ytex[i - 0],    active_material]);
                        }
                    } else {
                        err = "Malformed face found (line " + string(line_number) + ")";
                    }
                    #endregion
                    break;
                case "s":   // surface shading
                    break;
                case "mtllib":  // specify the mtllib file
                    #region mtl data
                    var material_name = ds_queue_concatenate(q);
                    var filename = file_exists(material_name) ? material_name : base_path + material_name;
                    if (!file_exists(filename)) break;
                    materials[$ material_name] = new Material("").LoadFromFile(filename);
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
    
    if (err != "") {
        emu_dialog_notice("Could not load the model " + fn + ": " + err);
        return undefined;
    }
    
    var n = ds_list_size(temp_vertices);
    
    if (n == 0) {
        emu_dialog_notice("No face data found in the model " + fn);
        return undefined;
    }
    
    var buffers = { };
    
    var vc = 0;
    
    var bxx = [0, 0, 0];
    var byy = [0, 0, 0];
    var bzz = [0, 0, 0];
    var bnx, bny, bnz, bxtex, bytex, bcolor, balpha, bmtl;
    
    var max_alpha = 0;
    
    for (var i = 0; i < n; i++) {
        var v = temp_vertices[| i];
        
        bxx[vc] = v[0];
        byy[vc] = v[1];
        bzz[vc] = v[2];
        
        bnx = v[3];
        bny = v[4];
        bnz = v[5];
        
        bxtex = round_ext(v[6], 1 / 1024);
        bytex = round_ext(is_blender ? v[7] : (1 - v[7]), 1 / 1024);
        
        bcolor = v[8];
        balpha = v[9];
        bmtl = v[10];
        
        max_alpha = max(max_alpha, balpha);
        
        base_mtl ??= bmtl;
        
        if (!buffers[$ bmtl]) {
            buffers[$ bmtl] = buffer_create(1000, buffer_grow, 1);
        }
        
        var data = buffers[$ bmtl];
        
        vertex_point_complete_raw(data, bxx[vc], byy[vc], bzz[vc], bnx, bny, bnz, bxtex, bytex, bcolor, balpha);
        
        vc = ++vc % 3;
    }
    
    if (max_alpha < 0.05 && !warn_invisible) {
        emu_dialog_notice("All of the vertices in this model have a very low alpha. If this is intentional, you can ignore this message; if this is otherwise due to a quirk of the tool used to create it, you might want to hit the Invert Transparency option under the Other Tools menu to correct it.");
        warn_invisible = true;
    }
    
    var data = array_create(variable_struct_names_count(buffers));
    data[0] = buffers[$ base_mtl];
    buffer_resize(data[0], buffer_tell(data[0]));
    variable_struct_remove(buffers, base_mtl);
    
    var keys = variable_struct_get_names(buffers);
    for (var i = 0, n = array_length(keys); i < n; i++) {
        data[i + 1] = buffers[$ keys[i]];
        buffer_resize(data[i + 1], buffer_tell(data[i + 1]));
    }
    
    return data;
    
    if (everything) {
        var mesh = existing ? existing : new DataMesh(base_name);
        if (!existing) array_push(Game.meshes, mesh);
        
        if (!existing) {
            mesh.RecalculateBounds();
            internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
        }
        
        //This is untested and will probably break in a lot of places
        vbuffer_materials = variable_struct_get_names(vbuffers);
        for (var i = 0; i < array_length(vbuffer_materials); i++) {
            var mat = vbuffer_materials[i];
            mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffers[$ mat], buffer_fixed, 1), vbuffers[$ mat], base_name + "." + mat, fn);
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
}

function import_texture(fn) {
    // This is specifically for handling texture files dropped onto the UI
    var ts = tileset_create(fn);
    ts.name = filename_change_ext(filename_name(fn),"");
    
    if (!EmuOverlay.GetTop() || !(EmuOverlay.GetTop().flags & DialogFlags.IS_GENERIC_WARNING)) {
        var manager = dialog_create_manager_graphics();
        manager.contents_interactive = true;
        manager.flags |= DialogFlags.IS_GENERIC_WARNING;
        manager.SearchID("TYPE").value = 0;
        manager.SearchID("LIST").Select(array_length(Game.graphics.tilesets) - 1);
        manager.Refresh({ list: Game.graphics.tilesets, index: array_length(Game.graphics.tilesets) - 1 });
    }
    
    return ts;
}