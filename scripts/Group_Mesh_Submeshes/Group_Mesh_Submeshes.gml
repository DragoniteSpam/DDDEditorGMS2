function MeshSubmesh(source) constructor {
    self.buffer = undefined;
    self.vbuffer = undefined;
    self.owner = undefined;
    self.path = "";
    self.proto_guid = NULL;
    
    self.reflect_buffer = undefined;
    self.reflect_vbuffer = undefined;
    
    // overrides
    self.col_diffuse = c_white;
    self.alpha = 1;
    self.col_ambient = c_gray;
    self.col_specular = c_white;
    self.col_specular_exponent = 10;
    self.tex_base = NULL;
    self.tex_normal = NULL;
    self.tex_ambient = NULL;
    self.tex_specular_color = NULL;
    self.tex_specular_highlight = NULL;
    self.tex_alpha = NULL;
    self.tex_bump = NULL;
    self.tex_displacement = NULL;
    self.tex_stencil = NULL;
    
    // not serialized
    self.editor_visible = true;
    
    if (is_string(source)) {
        self.name = source;
    } else if (is_struct(source)) {
        self.name = source.name;
        self.path = source.path;
        self.proto_guid = source.proto_guid;
        
        self.col_diffuse = source[$ "col_diffuse"] ?? self.col_diffuse;
        self.alpha = source[$ "alpha"] ?? self.alpha;
        self.col_ambient = source[$ "col_ambient"] ?? self.col_ambient;
        self.col_specular = source[$ "col_specular"] ?? self.col_specular;
        self.col_specular_exponent = source[$ "col_specular_exponent"] ?? self.col_specular_exponent;
        self.tex_base = source[$ "tex_base"] ?? NULL;
        self.tex_normal = source[$ "tex_normal"] ?? NULL;
        self.tex_ambient = source[$ "tex_ambient"] ?? NULL;
        self.tex_specular_color = source[$ "tex_specular_color"] ?? NULL;
        self.tex_specular_highlight = source[$ "tex_specular_highlight"] ?? NULL;
        self.tex_alpha = source[$ "tex_alpha"] ?? NULL;
        self.tex_bump = source[$ "tex_bump"] ?? NULL;
        self.tex_displacement = source[$ "tex_displacement"] ?? NULL;
        self.tex_stencil = source[$ "tex_stencil"] ?? NULL;
        self.texture_scale = source[$ "texture_scale"] ?? NULL;
    }
    
    static LoadAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (file_exists(directory  + proto + ".vertex")) self.buffer = buffer_load(directory  + proto + ".vertex");
        if (file_exists(directory  + proto + ".reflect")) self.reflect_buffer = buffer_load(directory  + proto + ".reflect");
        
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.format);
        if (self.reflect_buffer) self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.format);
    };
    
    static SaveAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (self.buffer) buffer_save(self.buffer, directory  + proto + ".vertex");
        if (self.reflect_buffer) buffer_save(self.reflect_buffer, directory + proto + ".reflect");
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_datatype, self.proto_guid);
        buffer_write(buffer, buffer_u32, self.col_diffuse | (floor(self.alpha * 255) << 24));
        buffer_write(buffer, buffer_u32, self.col_ambient);
        buffer_write(buffer, buffer_u32, self.col_specular);
        buffer_write(buffer, buffer_f32, self.col_specular_exponent);
        buffer_write(buffer, buffer_datatype, self.tex_base);
        buffer_write(buffer, buffer_datatype, self.tex_normal);
        buffer_write(buffer, buffer_datatype, self.tex_ambient);
        buffer_write(buffer, buffer_datatype, self.tex_specular_color);
        buffer_write(buffer, buffer_datatype, self.tex_specular_highlight);
        buffer_write(buffer, buffer_datatype, self.tex_alpha);
        buffer_write(buffer, buffer_datatype, self.tex_bump);
        buffer_write(buffer, buffer_datatype, self.tex_displacement);
        buffer_write(buffer, buffer_datatype, self.tex_stencil);
        buffer_write(buffer, buffer_u8, ((!!self.buffer) << 1) | (!!self.reflect_buffer));
        
        if (self.buffer) {
            buffer_write_vertex_buffer(buffer, self.buffer);
        }
        if (self.reflect_buffer) {
            buffer_write_vertex_buffer(buffer, self.reflect_buffer);
        }
    };
    
    static CreateJSON = function() {
        return {
            name: self.name,
            path: self.path,
            proto_guid: self.proto_guid,
            
            col_diffuse: self.col_diffuse,
            alpha: self.alpha,
            col_ambient: self.col_ambient,
            col_specular: self.col_specular,
            col_specular_exponent: self.col_specular_exponent,
            tex_base: self.tex_base,
            tex_normal: self.tex_normal,
            tex_ambient: self.tex_ambient,
            tex_specular_color: self.tex_specular_color,
            tex_specular_highlight: self.tex_specular_highlight,
            tex_alpha: self.tex_alpha,
            tex_bump: self.tex_bump,
            tex_displacement: self.tex_displacement,
            tex_stencil: self.tex_stencil,
        };
    };
    
    static Destroy = function() {
        if (self.buffer) buffer_delete(self.buffer);
        if (self.vbuffer) {
            switch (self.owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(self.vbuffer); break;
            }
        }
        if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
        if (self.reflect_vbuffer) {
            switch (self.owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(self.reflect_vbuffer); break;
            }
        }
    };
    
    static Clone = function() {
        var cloned_data = new MeshSubmesh(self.name);
        if (self.buffer) {
            cloned_data.buffer = buffer_clone(self.buffer, buffer_fixed, 1);
            cloned_data.vbuffer = vertex_create_buffer_from_buffer(cloned_data.buffer, Stuff.graphics.format);
        }
        if (self.reflect_buffer) {
            cloned_data.reflect_buffer = buffer_clone(self.reflect_buffer, buffer_fixed, 1);
            cloned_data.reflect_vbuffer = vertex_create_buffer_from_buffer(cloned_data.reflect_buffer, Stuff.graphics.format);
        }
        cloned_data.path = self.path;
        
        return cloned_data;
    };
    
    static ImportReflection = function() {
        var data = import_3d_model_generic(get_open_filename_mesh(), true);
        if (data == undefined) return;
        internalDeleteReflect();
        self.reflect_buffer = data[0].buffer;
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(data[0].buffer, Stuff.graphics.format);
        vertex_freeze(self.reflect_vbuffer);
    };
    
    static GenerateReflections = function() {
        if (!self.buffer) return;
        internalDeleteReflect();
        self.reflect_buffer = vertex_to_reflect_buffer(self.buffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.format);
        vertex_freeze(self.reflect_vbuffer);
    };
    
    static SwapReflections = function() {
        var t = self.buffer;
        self.buffer = self.reflect_buffer;
        self.reflect_buffer = t;
        
        t = self.vbuffer;
        self.vbuffer = self.reflect_vbuffer;
        self.reflect_vbuffer = t;
    };
    
    static Reload = function(filename = undefined) {
        var old_path = self.path;
        if (filename != undefined) {
            self.path = filename;
        }
        
        var data = import_3d_model_generic(self.path);
        if (data == undefined) {
            self.path = old_path;
            return;
        }
        
        var index = array_search(self.owner.submeshes, self);
        if (index < array_length(data)) {
            self.SetBufferData(data[index].buffer);
        }
        
        // delete all imported buffers that were not set to the mesh
        for (var i = 0, n = array_length(data); i < n; i++) {
            if (i != index) {
                buffer_delete(data[i].buffer);
            }
        }
    };
    
    static SetBufferData = function(raw_buffer) {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        if (self.buffer) buffer_delete(self.buffer);
        
        self.buffer = raw_buffer;
        self.vbuffer = vertex_create_buffer_from_buffer(raw_buffer, Stuff.graphics.format);
        vertex_freeze(self.vbuffer);
        
        if (self.reflect_buffer) {
            buffer_delete(self.reflect_buffer);
            vertex_delete_buffer(self.reflect_vbuffer);
            self.GenerateReflections();
        }
    };
    
    // Appends vertex data onto the end of an existing buffer; this is mostly
    // used with the "combine submeshes" option in the Mesh editor
    static AddBufferData = function(raw_buffer) {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        var new_size = buffer_get_size(raw_buffer);
        if (!self.buffer) {
            self.buffer = buffer_create(new_size, buffer_grow, 1);
        }
        var old_size = buffer_get_size(self.buffer);
        buffer_resize(self.buffer, old_size + new_size);
        buffer_copy(raw_buffer, 0, new_size, self.buffer, old_size);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.format);
        vertex_freeze(self.vbuffer);
        
        if (self.reflect_buffer) {
            buffer_delete(self.reflect_buffer);
            vertex_delete_buffer(self.reflect_vbuffer);
            self.GenerateReflections();
        }
    };
    
    self.SetMaterial = function(material) {
        self.col_diffuse = material.col_diffuse;
        self.alpha = material.alpha;
        self.col_ambient = material.col_ambient;
        self.col_specular = material.col_specular;
        self.col_specular_exponent = material.col_specular_exponent;
        self.tex_base = material.tex_base;
        self.tex_normal = material.tex_normal;
        self.tex_ambient = material.tex_ambient;
        self.tex_specular_color = material.tex_specular_color;
        self.tex_specular_highlight = material.tex_specular_highlight;
        self.tex_alpha = material.tex_alpha;
        self.tex_bump = material.tex_bump;
        self.tex_displacement = material.tex_displacement;
        self.tex_stencil = material.tex_stencil;
    };
    
    static internalDeleteUpright = function() {
        if (self.buffer) buffer_delete(self.buffer);
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
    };
    
    static internalDeleteReflect = function() {
        if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
    };
    
    static internalSetVertexBuffer = function() {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.format);
        vertex_freeze(self.vbuffer);
    };
    
    static internalSetReflectVertexBuffer = function() {
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.format);
        vertex_freeze(self.reflect_vbuffer);
    };
}