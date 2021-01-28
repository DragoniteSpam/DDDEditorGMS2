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
}