function Material(
        source = undefined,
        col_diffuse = c_white,
        alpha = 1,
        col_specular = c_black,
        col_specular_exponent = 10,
        tex_base = NULL,
        tex_normal = NULL,
        tex_specular_color = NULL,
        tex_specular_highlight = NULL
    ) constructor {
    
    self.name = "Material";
    self.col_diffuse = col_diffuse;
    self.alpha = alpha;
    self.col_specular = col_specular;
    self.col_specular_exponent = col_specular_exponent;
    self.tex_base = tex_base;
    self.tex_normal = tex_normal;
    self.tex_specular_color = tex_specular_color;
    self.tex_specular_highlight = tex_specular_highlight;
    
    if (is_struct(source)) {
        self.name = source.name;
        self.col_diffuse = source.col_diffuse;
        self.alpha = source.alpha;
        self.col_specular = source.col_specular;
        self.col_specular_exponent = source.col_specular_exponent;
        self.tex_base = source.tex_base;
        self.tex_normal = source[$ "tex_normal"] ?? NULL;
        self.tex_specular_color = source.tex_specular_color;
        self.tex_specular_highlight = source.tex_specular_highlight;
    } else {
        self.name = source;
    }
    
    self.Clone = function() {
        return new Material(self);
    };
    
    self.CreateJSON = function() {
        var json = { };
        json.col_diffuse = self.col_diffuse;
        json.alpha = self.alpha;
        json.col_specular = self.col_specular;
        json.col_specular_exponent = self.col_specular_exponent;
        json.tex_base = self.tex_base;
        json.tex_normal = self.tex_normal;
        json.tex_specular_color = self.tex_specular_color;
        json.tex_specular_highlight = self.tex_specular_highlight;
        
        return json;
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u32, self.col_diffuse | (floor(self.alpha * 255) << 24));
        buffer_write(buffer, buffer_u32, self.col_specular);
        buffer_write(buffer, buffer_f32, self.col_specular_exponent);
        buffer_write(buffer, buffer_datatype, self.tex_base);
        buffer_write(buffer, buffer_datatype, self.tex_normal);
        buffer_write(buffer, buffer_datatype, self.tex_specular_color);
        buffer_write(buffer, buffer_datatype, self.tex_specular_highlight);
    };
    
    self.HasAnyTextures = function() {
        if (self.tex_base != NULL) return true;
        if (self.tex_normal != NULL) return true;
        if (self.tex_specular_color != NULL) return true;
        if (self.tex_specular_highlight != NULL) return true;
        return false;
    };
}