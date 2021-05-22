function MeshSubmesh(name) constructor {
    self.name = name;
    self.buffer = undefined;
    self.vbuffer = undefined;
    self.wbuffer = undefined;
    self.owner = undefined;
    self.path = "";
    self.proto_guid = NULL;
    
    self.reflect_buffer = undefined;
    self.reflect_vbuffer = undefined;
    self.reflect_wbuffer = undefined;
    
    static _destructor = function() {
        if (buffer) buffer_delete(buffer);
        if (wbuffer) vertex_delete_buffer(wbuffer);
        if (vbuffer) {
            switch (owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(vbuffer); break;
                case MeshTypes.SMF: smf_model_destroy(vbuffer); break;
            }
        }
        if (reflect_buffer) buffer_delete(reflect_buffer);
        if (reflect_wbuffer) buffer_delete(reflect_wbuffer);
        if (reflect_vbuffer) {
            switch (owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(reflect_vbuffer); break;
                case MeshTypes.SMF: smf_model_destroy(reflect_vbuffer); break;
            }
        }
    };
    
    static Clone = function() {
        var cloned_data = new MeshSubmesh(self.name);
        if (self.buffer) {
            cloned_data.buffer = buffer_clone(self.buffer, buffer_fixed, 1);
            cloned_data.vbuffer = vertex_create_buffer_from_buffer(cloned_data.buffer, Stuff.graphics.vertex_format);
            cloned_data.wbuffer = buffer_to_wireframe(cloned_data.buffer);
        }
        if (self.reflect_buffer) {
            cloned_data.reflect_buffer = buffer_clone(self.reflect_buffer, buffer_fixed, 1);
            cloned_data.reflect_vbuffer = vertex_create_buffer_from_buffer(cloned_data.reflect_buffer, Stuff.graphics.vertex_format);
            cloned_data.reflect_wbuffer = buffer_to_wireframe(cloned_data.reflect_buffer);
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
            self.reflect_wbuffer = buffer_to_wireframe(self.reflect_buffer);
            vertex_freeze(self.reflect_wbuffer);
        }
    };
    
    static GenerateReflections = function() {
        if (!self.buffer) return;
        internalDeleteReflect();
        self.reflect_vbuffer = buffer_to_reflect(self.buffer);
        self.reflect_buffer = buffer_create_from_vertex_buffer(self.reflect_vbuffer, buffer_fixed, 1);
        self.reflect_wbuffer = buffer_to_wireframe(self.reflect_buffer);
        vertex_freeze(self.reflect_vbuffer);
        vertex_freeze(self.reflect_wbuffer);
    };
    
    static SwapReflections = function() {
        var t = self.buffer;
        self.buffer = self.reflect_buffer;
        self.reflect_buffer = t;
        
        var t = self.vbuffer;
        self.vbuffer = self.reflect_vbuffer;
        self.reflect_vbuffer = t;
        
        var t = self.wbuffer;
        self.wbuffer = self.reflect_wbuffer;
        self.reflect_wbuffer = t;
    };
    
    static SetNormalsZero = function() {
        if (self.buffer) {
            internalSetNormalsZero(self.buffer, 1);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsZero(self.reflect_buffer, -1);
            internalSetReflectVertexBuffer();
        }
    };
    
    static SetNormalsFlat = function() {
        if (self.buffer) {
            internalSetNormalsFlat(self.buffer);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsFlat(self.reflect_buffer);
            internalSetReflectVertexBuffer();
        }
    };
    
    static SetNormalsSmooth = function(threshold) {
        if (self.buffer) {
            internalSetNormalsSmooth(self.buffer, threshold);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsSmooth(self.reflect_buffer, threshold);
            internalSetReflectVertexBuffer();
        }
    };
    
    static Reload = function() {
        var index = ds_list_find_index(self.owner.submeshes, self);
        if (file_exists(self.path)) {
            switch (filename_ext(self.path)) {
                case ".obj": import_obj(self.path, undefined, self.owner, index); break;
                case ".d3d": case ".gmmod": import_d3d(self.path, undefined, false, self.owner, index); break;
                case ".smf": import_smf(self.path, self.owner, index); break;
            }
        }
    };
    
    static AddBufferData = function(raw_buffer) {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
        var new_size = buffer_get_size(raw_buffer);
        if (!self.buffer) {
            self.buffer = buffer_create(new_size, buffer_grow, 1);
        }
        var old_size = buffer_get_size(self.buffer);
        buffer_resize(self.buffer, old_size + new_size);
        buffer_copy(raw_buffer, 0, new_size, self.buffer, old_size);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
        self.wbuffer = buffer_to_wireframe(self.buffer);
        vertex_freeze(self.wbuffer);
        
        if (self.reflect_buffer) {
            buffer_delete(self.reflect_buffer);
            vertex_delete_buffer(self.reflect_wbuffer);
            vertex_delete_buffer(self.reflect_vbuffer);
            self.GenerateReflections();
        }
    };
    
    static internalDeleteUpright = function() {
        if (self.buffer) buffer_delete(self.buffer);
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
    };
    
    static internalDeleteReflect = function() {
        if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
        if (self.reflect_wbuffer) vertex_delete_buffer(self.reflect_wbuffer);
    };
    
    static internalSetVertexBuffer = function() {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
        self.wbuffer = buffer_to_wireframe(self.buffer);
        vertex_freeze(self.wbuffer);
    };
    
    static internalSetReflectVertexBuffer = function() {
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
        if (self.reflect_wbuffer) vertex_delete_buffer(self.reflect_wbuffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.reflect_vbuffer);
        self.reflect_wbuffer = buffer_to_wireframe(self.reflect_buffer);
        vertex_freeze(self.reflect_wbuffer);
    };
    
    static internalSetNormalsZero = function(buffer, val) {
        buffer_seek(buffer, buffer_seek_start, 0);
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            buffer_poke(buffer, position + VERTEX_SIZE + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE + 20, buffer_f32, val);
            position += VERTEX_SIZE;
        }
    };
    
    static internalSetNormalsFlat = function(buffer) {
        buffer_seek(buffer, buffer_seek_start, 0);
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var normals = triangle_normal(
                // t1
                buffer_peek(buffer, position, buffer_f32),
                buffer_peek(buffer, position + 4, buffer_f32),
                buffer_peek(buffer, position + 8, buffer_f32),
                // t2
                buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
                // t3
                buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32),
            );
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, normals[0]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, normals[1]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, normals[2]);
            
            position += VERTEX_SIZE * 3;
        }
    }
    
    static internalSetNormalsSmooth = function(buffer, threshold) {
        threshold = dcos(threshold);
        internalSetNormalsFlat(buffer);
        
        static triangleKey = function(x, y, z) {
            var p = 3;
            return string_format(x, 1, p) + "," + string_format(y, 1, p) + "," + string_format(z, 1, p);
        };
        
        buffer_seek(buffer, buffer_seek_start, 0);
        var normal_cache = { };
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var xx = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 00, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 00, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 00, buffer_f32)
            ];
            var yy = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 04, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 04, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 04, buffer_f32)
            ];
            var zz = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 08, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 08, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 08, buffer_f32)
            ];
            var normals = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32)
            ];
            
            for (var i = 0; i < 3; i++) {
                var key = triangleKey(xx[i], yy[i], zz[i]);
                if (normal_cache[$ key] != undefined) {
                    var existing = normal_cache[$ key];
                    existing[@ 0] += normals[0];
                    existing[@ 1] += normals[1];
                    existing[@ 2] += normals[2];
                } else {
                    normal_cache[$ key] = normals;
                }
            }
            
            position += VERTEX_SIZE * 3;
        }
        
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var xx = buffer_peek(buffer, position + 00, buffer_f32);
            var yy = buffer_peek(buffer, position + 04, buffer_f32);
            var zz = buffer_peek(buffer, position + 08, buffer_f32);
            var nx = buffer_peek(buffer, position + 12, buffer_f32);
            var ny = buffer_peek(buffer, position + 16, buffer_f32);
            var nz = buffer_peek(buffer, position + 20, buffer_f32);
            
            var n = vector3_normalize(normal_cache[$ triangleKey(xx, yy, zz)]);
            if (dot_product_3d(n[0], n[1], n[2], nx, ny, nz) > threshold) {
                buffer_poke(buffer, position + 12, buffer_f32, n[0]);
                buffer_poke(buffer, position + 16, buffer_f32, n[1]);
                buffer_poke(buffer, position + 20, buffer_f32, n[2]);
            }
            
            position += VERTEX_SIZE;
        }
    }
}