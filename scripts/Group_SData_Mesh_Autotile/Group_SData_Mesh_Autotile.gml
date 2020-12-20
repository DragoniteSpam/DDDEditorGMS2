function DataMeshAutotile(name) : SData(name) constructor {
    static MeshAutotileLayer = function() constructor {
        static MeshVertexBufferData = function(buffer, vbuffer) constructor {
            self.buffer = buffer;
            self.vbuffer = vbuffer;
            self.Destroy = function() {
                var valid = !!self.vbuffer;
                if (self.buffer) buffer_delete(self.buffer);
                if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
                self.buffer = undefined;
                self.vbuffer = undefined;
                return valid;
            }
        };
        
        self.tiles = array_create(AUTOTILE_COUNT);
        for (var i = 0; i < AUTOTILE_COUNT; i++) {
            self.tiles[i] = new MeshVertexBufferData(undefined, undefined);
        }
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

enum MeshAutotileLayers {
    TOP, MIDDLE, BASE, BOTTOM,
    __COUNT
}