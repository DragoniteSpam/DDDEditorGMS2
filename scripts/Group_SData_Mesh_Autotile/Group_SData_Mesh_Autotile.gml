function DataMeshAutotile(name) : SData(name) constructor {
    static MeshAutotileLayer = function() constructor {
        static MeshVertexBufferData = function(buffer, vbuffer) constructor {
            self.buffer = undefined;
            self.vbuffer = undefined;
            self.wbuffer = undefined;
            
            static Set = function(buffer, vbuffer) {
                Destroy();
                self.buffer = buffer;
                self.vbuffer = vbuffer;
                if (buffer) self.wbuffer = buffer_to_wireframe(buffer);
            }
            
            static Destroy = function() {
                var valid = !!self.vbuffer;
                if (self.buffer) buffer_delete(self.buffer);
                if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
                if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
                self.buffer = undefined;
                self.vbuffer = undefined;
                self.wbuffer = undefined;
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