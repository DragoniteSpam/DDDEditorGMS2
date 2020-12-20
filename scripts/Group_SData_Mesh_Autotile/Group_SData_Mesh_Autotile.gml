function DataMeshAutotile(name) : SData(name) constructor {
    static MeshVertexBufferData = function(buffer, vbuffer) constructor {
        self.buffer = buffer;
        self.vbuffer = vbuffer;
        self.Destroy = function() {
            if (self.buffer) buffer_delete(self.buffer);
            if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        }
    };
    
    self.layers = array_create(MeshAutotileLayers.__COUNT);
    for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
        self.layers[i] = new self.MeshVertexBufferData(undefined, undefined);
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