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
            vertex_delete_buffer(self.vbuffer);
            self.vbuffer = vertex_create_buffer_from_buffer(self.vbuffer, Stuff.graphics.vertex_format);
            vertex_freeze(self.vbuffer);
        }
        if (self.reflect_buffer, -1) {
            internalSetNormalsZero(self.buffer, -1);
            vertex_delete_buffer(self.vbuffer);
            self.vbuffer = vertex_create_buffer_from_buffer(self.vbuffer, Stuff.graphics.vertex_format);
            vertex_freeze(self.vbuffer);
        }
    };
    
    static SetNormalsFlat = function() {
        
    };
    
    static SetNormalsSmooth = function() {
        
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
}