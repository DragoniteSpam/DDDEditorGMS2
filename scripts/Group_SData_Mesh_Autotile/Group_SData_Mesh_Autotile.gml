function DataMeshAutotile() : SData() constructor {
    static MeshVertexBufferData = function(buffer, vbuffer) {
        self.buffer = buffer;
        self.vbuffer = vbuffer;
        Destroy = function() {
            if (self.buffer) buffer_delete(self.buffer);
            if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        }
    };
    
    layers = array_create(MeshAutotileLayers.__COUNT);
    for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
        layers[i] = new MeshVertexBufferData(undefined, undefined);
    }
    
    Destroy = function() {
        for (var i = 0; i < MeshAutotileLayers.__COUNT; i++) {
            layers[i].Destroy();
        }
    };
}

enum MeshAutotileLayers {
    TOP, MIDDLE, BASE,
    __COUNT
}