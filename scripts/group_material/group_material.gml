function Material(
        source,
        col_diffuse = c_white,
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
        buffer_write(buffer, buffer_u32, self.col_diffuse);
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
}