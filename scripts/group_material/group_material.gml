function Material(
        source,
        col_diffuse = c_white,
        alpha = 1,
        col_ambient = c_white,
        col_specular = c_black,
        col_specular_exponent = 10,
        tex_base = NULL,
        tex_normal = NULL,
        tex_ambient = NULL,
        tex_specular = NULL,
        tex_specular_highlight = NULL,
        tex_alpha = NULL,
        tex_bump = NULL,
        tex_displacement = NULL,
        tex_stencil = NULL
    ) : SData(source) constructor {
    
    self.col_diffuse = col_diffuse;
    self.alpha = alpha;
    self.col_ambient = col_ambient;
    self.col_specular = col_specular;
    self.col_specular_exponent = col_specular_exponent;
    self.tex_base = tex_base;
    self.tex_normal = tex_normal;
    self.tex_ambient = tex_ambient;
    self.tex_specular = tex_specular;
    self.tex_specular_highlight = tex_specular_highlight;
    self.tex_alpha = tex_alpha;
    self.tex_bump = tex_bump;
    self.tex_displacement = tex_displacement;
    self.tex_stencil = tex_stencil;
    
    if (is_struct(source)) {
        self.col_diffuse = source.col_diffuse;
        self.alpha = source.alpha;
        self.col_ambient = source.col_ambient;
        self.col_specular = source.col_specular;
        self.col_specular_exponent = source.col_specular_exponent;
        self.tex_base = source.tex_base;
        self.tex_normal = source.tex_normal;
        self.tex_ambient = source.tex_ambient;
        self.tex_specular = source.tex_specular;
        self.tex_specular_highlight = source.tex_specular_highlight;
        self.tex_alpha = source.tex_alpha;
        self.tex_bump = source.tex_bump;
        self.tex_displacement = source.tex_displacement;
        self.tex_stencil = source.tex_stencil;
    }
    
    self.Clone = function() {
        return new Material(self);
    };
    
    self.CreateJSON = function() {
        var json = self.CreateJSONBase();
        json.col_diffuse = self.col_diffuse;
        json.alpha = self.alpha;
        json.col_ambient = self.col_ambient;
        json.col_specular = self.col_specular;
        json.col_specular_exponent = self.col_specular_exponent;
        json.tex_base = self.tex_base;
        json.tex_normal = self.tex_normal;
        json.tex_ambient = self.tex_ambient;
        json.tex_specular = self.tex_specular;
        json.tex_specular_highlight = self.tex_specular_highlight;
        json.tex_alpha = self.tex_alpha;
        json.tex_bump = self.tex_bump;
        json.tex_displacement = self.tex_displacement;
        json.tex_stencil = self.tex_stencil;
        
        return json;
    };
    
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.col_diffuse | (floor(self.col_alpha * 255) << 24));
        buffer_write(buffer, buffer_u32, self.col_ambient);
        buffer_write(buffer, buffer_u32, self.col_specular);
        buffer_write(buffer, buffer_f32, self.col_specular_exponent);
        buffer_write(buffer, buffer_datatype, self.tex_base);
        buffer_write(buffer, buffer_datatype, self.tex_ambient);
        buffer_write(buffer, buffer_datatype, self.tex_specular_color);
        buffer_write(buffer, buffer_datatype, self.tex_specular_highlight);
        buffer_write(buffer, buffer_datatype, self.tex_alpha);
        buffer_write(buffer, buffer_datatype, self.tex_bump);
        buffer_write(buffer, buffer_datatype, self.tex_displacement);
        buffer_write(buffer, buffer_datatype, self.tex_stencil);
    };
    
    self.LoadFromFile = function(filename, is_blender) {
        static material_cache = { };
        
        if (material_cache[$ filename]) return material_cache[$ filename].Clone();
        
        var base_path = filename_path(filename);
        var matfile = file_text_open_read(filename);
        self.name = filename_name(filename_change_ext(filename, ""));
                        
        while (!file_text_eof(matfile)) {
            var line = file_text_read_string(matfile);
            file_text_readln(matfile);
            var spl = split(line, " ");
            switch (ds_queue_dequeue(spl)) {
                case "newmtl":
                    self.name = ds_queue_dequeue(spl);
                    break;
                case "Kd":  // Diffuse color (the color we're concerned with)
                    self.col_diffuse = colour_replace_red(self.col_diffuse, real(ds_queue_dequeue(spl)) * 255);
                    self.col_diffuse = colour_replace_green(self.col_diffuse, real(ds_queue_dequeue(spl)) * 255);
                    self.col_diffuse = colour_replace_blue(self.col_diffuse, real(ds_queue_dequeue(spl)) * 255);
                    break;
                case "d":   // "dissolved" (alpha)
                case "Tr":  // "transparent" (blender thinks this should be 1 - alpha???)
                    self.alpha = is_blender ? (1 - real(ds_queue_dequeue(spl))) : real(ds_queue_dequeue(spl));
                    break;
                case "map_Kd":                  // dissolve (base) texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_base = tileset_create(texfn);
                    self.tex_base.name = self.name + ".BaseTexture";
                    break;
                case "map_Ka":                  // ambient texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_base = tileset_create(texfn);
                    self.tex_ambient.name = self.name + ".AmbientMap";
                    break;
                case "map_Ks":                  // specular color texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_specular_color = tileset_create(texfn);
                    self.tex_specular_color.name = self.name + ".SpecularColorMap";
                    break;
                case "map_Ns":                  // specular highlight texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_specular_highlight = tileset_create(texfn);
                    self.tex_specular_highlight.name = self.name + ".SpecularHighlightMap";
                    break;
                case "map_d":                   // alpha texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_alpha = tileset_create(texfn);
                    self.tex_alpha.name = self.name + ".AlphaMap";
                    break;
                case "map_bump":                // bump texture
                case "bump":
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_bump = tileset_create(texfn);
                    self.tex_bump.name = self.name + ".BumpMap";
                    break;
                case "disp":                    // displacement texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_displace = tileset_create(texfn);
                    self.tex_displace.name = self.name + ".DisplacementMap";
                    break;
                case "decal":                   // stencil decal texture
                    var texfn = ds_queue_concatenate(spl);
                    if (!file_exists(texfn)) texfn = base_path + texfn;
                    self.tex_decal = tileset_create(texfn);
                    self.tex_decal.name = self.name + ".StencilDecal";
                    break;
                default:    // There are way more attributes available than I'm going to use later - maybe
                    break;
            }
            ds_queue_destroy(spl);
        }
        file_text_close(matfile);
        
        return self;
    };
}