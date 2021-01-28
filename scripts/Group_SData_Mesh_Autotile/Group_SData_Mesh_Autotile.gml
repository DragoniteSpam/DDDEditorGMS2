function DataMeshAutotile(name) : SData(name) constructor {
    static MeshAutotileLayer = function() constructor {
        static MeshVertexBufferData = function(buffer, vbuffer) constructor {
            self.buffer = undefined;
            self.vbuffer = undefined;
            self.wbuffer = undefined;
            self.reflect_buffer = undefined;
            self.reflect_vbuffer = undefined;
            self.reflect_wbuffer = undefined;
            
            static Set = function(buffer, vbuffer) {
                DestroyUpright();
                self.buffer = buffer;
                self.vbuffer = vbuffer;
                if (buffer) self.wbuffer = buffer_to_wireframe(buffer);
            };
            
            static SetReflect = function(buffer, vbuffer) {
                DestroyReflect();
                DestroyUpright();
                self.reflect_buffer = buffer;
                self.reflect_vbuffer = vbuffer;
                if (buffer) self.reflect_wbuffer = buffer_to_wireframe(buffer);
            };
            
            static Destroy = function() {
                DestroyUpright();
                DestroyReflect();
            };
            
            static DestroyUpright = function() {
                var valid = !!self.vbuffer;
                if (self.buffer) buffer_delete(self.buffer);
                if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
                if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
                self.buffer = undefined;
                self.vbuffer = undefined;
                self.wbuffer = undefined;
                return valid;
            };
            
            static DestroyReflect = function() {
                var valid = !!self.reflect_vbuffer;
                if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
                if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
                if (self.reflect_wbuffer) vertex_delete_buffer(self.reflect_wbuffer);
                self.reflect_buffer = undefined;
                self.reflect_vbuffer = undefined;
                self.reflect_wbuffer = undefined;
                return valid;
            };
            
            Set(buffer, vbuffer);
        };
        
        self.tiles = array_create(AUTOTILE_COUNT);
        for (var i = 0; i < AUTOTILE_COUNT; i++) {
            self.tiles[i] = new MeshVertexBufferData(undefined, undefined);
        }
        
        self.Destroy = function() {
            for (var i = 0; i < AUTOTILE_COUNT; i++) {
                self.tiles[i].Destroy();
            }
        };
    };
    
    self.layers = array_create(MeshAutotileLayers.__COUNT);
    for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
        self.layers[i] = new MeshAutotileLayer();
    }
    
    self.baseDestroy = self.Destroy;
    self.Destroy = function() {
        self.baseDestroy();
        for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
            self.layers[i].Destroy();
        }
    };
}