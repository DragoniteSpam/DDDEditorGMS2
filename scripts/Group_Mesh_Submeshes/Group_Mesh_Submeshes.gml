function MeshSubmesh(source) constructor {
    self.buffer = undefined;
    self.vbuffer = undefined;
    self.owner = undefined;
    self.path = "";
    self.proto_guid = NULL;
    
    self.reflect_buffer = undefined;
    self.reflect_vbuffer = undefined;
    
    if (is_struct(source)) {
        self.name = source.name;
        self.path = source.path;
        self.proto_guid = source.proto_guid;
    } else {
        self.name = source;
    }
    
    static LoadAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (file_exists(directory  + proto + ".vertex")) self.buffer = buffer_load(directory  + proto + ".vertex");
        if (file_exists(directory  + proto + ".reflect")) self.reflect_buffer = buffer_load(directory  + proto + ".reflect");
        
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        if (self.reflect_buffer) self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
    };
    
    static SaveAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (self.buffer) buffer_save(self.buffer, directory  + proto + ".vertex");
        if (self.reflect_buffer) buffer_save(self.reflect_buffer, directory + proto + ".reflect");
    };
    
    static Export = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_datatype, self.proto_guid);
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
            cloned_data.vbuffer = vertex_create_buffer_from_buffer(cloned_data.buffer, Stuff.graphics.vertex_format);
        }
        if (self.reflect_buffer) {
            cloned_data.reflect_buffer = buffer_clone(self.reflect_buffer, buffer_fixed, 1);
            cloned_data.reflect_vbuffer = vertex_create_buffer_from_buffer(cloned_data.reflect_buffer, Stuff.graphics.vertex_format);
        }
        cloned_data.path = self.path;
        
        return cloned_data;
    };
    
    static ImportReflection = function() {
        var fn = get_open_filename_mesh();
        if (file_exists(fn)) {
            var data = import_3d_model_generic(fn, false, true, undefined, 0);
            internalDeleteReflect();
            self.reflect_vbuffer = data[0];
            self.reflect_buffer = data[1];
            vertex_freeze(self.reflect_vbuffer);
        }
    };
    
    static GenerateReflections = function() {
        if (!self.buffer) return;
        internalDeleteReflect();
        self.reflect_vbuffer = vertex_to_reflect(self.buffer);
        self.reflect_buffer = buffer_create_from_vertex_buffer(self.reflect_vbuffer, buffer_fixed, 1);
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
    
    static Reload = function() {
        var index = array_search(self.owner.submeshes, self);
        if (file_exists(self.path)) {
            switch (filename_ext(self.path)) {
                case ".obj": import_obj(self.path, undefined, self.owner, index); break;
                case ".d3d": case ".gmmod": import_d3d(self.path, undefined, false, self.owner, index); break;
                case ".smf": break;
            }
        }
    };
    
    static AddBufferData = function(raw_buffer) {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        var new_size = buffer_get_size(raw_buffer);
        if (!self.buffer) {
            self.buffer = buffer_create(new_size, buffer_grow, 1);
        }
        var old_size = buffer_get_size(self.buffer);
        buffer_resize(self.buffer, old_size + new_size);
        buffer_copy(raw_buffer, 0, new_size, self.buffer, old_size);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
        
        if (self.reflect_buffer) {
            buffer_delete(self.reflect_buffer);
            vertex_delete_buffer(self.reflect_vbuffer);
            self.GenerateReflections();
        }
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
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
    };
    
    static internalSetReflectVertexBuffer = function() {
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.reflect_vbuffer);
    };
}