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
        if (reflect_wbuffer) {
            switch (owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(reflect_wbuffer); break;
                case MeshTypes.SMF: smf_model_destroy(reflect_wbuffer); break;
            }
        }
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
    
    static internalSetVertexBuffer = function() {
        if (self.buffer) vertex_delete_buffer(self.vbuffer);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
    };
    
    static internalSetReflectVertexBuffer = function() {
        if (self.reflect_buffer) vertex_delete_buffer(self.reflect_vbuffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.reflect_vbuffer);
    };
    
    static internalSetNormalsZero = function(buffer, nz) {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, nz);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, nz);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, nz);
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
    };
    
    static internalSetNormalsFlat = function(buffer) {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
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
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
    }
    
    static internalSetNormalsSmooth = function(buffer, threshold) {
        threshold = dcos(threshold);
        internalSetNormalsFlat(buffer);
        
        buffer_seek(buffer, buffer_seek_start, 0);
        var normal_map = { };
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            var xx = [
                buffer_peek(buffer, position, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32)
            ];
            var yy = [
                buffer_peek(buffer, position + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32)
            ];
            var zz = [
                buffer_peek(buffer, position + 8, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32)
            ];
            
            var normals = triangle_normal(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
            
            for (var i = 0; i < 3; i++) {
                var key = string(xx[i]) + "," + string(yy[i]) + "," + string(zz[i]);
                if (normal_map[$ key] != undefined) {
                    var existing = normal_map[? key];
                    normal_map[$ key] = [existing[0] + normals[0], existing[1] + normals[1], existing[2] + normals[2]];
                } else {
                    normal_map[$ key] = normals;
                }
            }
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            var xx = buffer_peek(buffer, position, buffer_f32);
            var yy = buffer_peek(buffer, position + 4, buffer_f32);
            var zz = buffer_peek(buffer, position + 8, buffer_f32);
            var nx = buffer_peek(buffer, position + 12, buffer_f32);
            var ny = buffer_peek(buffer, position + 16, buffer_f32);
            var nz = buffer_peek(buffer, position + 20, buffer_f32);
            var key = string(xx) + "," + string(yy) + "," + string(zz);
            
            var n = vector3_normalize(normal_map[$ key]);
            if (dot_product_3d(n[0], n[1], n[2], nx, ny, nz) > threshold) {
                buffer_poke(buffer, position + 12, buffer_f32, n[0]);
                buffer_poke(buffer, position + 16, buffer_f32, n[1]);
                buffer_poke(buffer, position + 20, buffer_f32, n[2]);
            }
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
        }
    }
}