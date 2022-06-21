function DataMeshAutotile(source) : SData(source) constructor {
    static MeshAutotileLayer = function() constructor {
        static MeshVertexBufferData = function(buffer) constructor {
            self.buffer = undefined;
            self.vbuffer = undefined;
            self.reflect_buffer = undefined;
            self.reflect_vbuffer = undefined;
            
            static LoadAsset = function(filename) {
                self.DestroyUpright();
                self.DestroyReflect();
                // not all of these may exist
                if (file_exists(filename + ".vertex")) self.buffer = buffer_load(filename + ".vertex");
                if (file_exists(filename + ".reflect")) self.reflect_buffer = buffer_load(filename + ".reflect");
                try { self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.format); } catch (e) { }
                try { self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.format); } catch (e) { }
            };
            
            static SaveAsset = function(filename) {
                if (self.buffer) buffer_save(self.buffer, filename + ".vertex");
                if (self.reflect_buffer) buffer_save(self.reflect_buffer, filename + ".reflect");
            };
            
            static Set = function(buffer) {
                static format = Stuff.graphics.format;
                self.DestroyUpright();
                self.buffer = buffer;
                if (buffer != undefined)
                    self.vbuffer = vertex_create_buffer_from_buffer(buffer, format);
            };
            
            static SetReflect = function(buffer) {
                static format = Stuff.graphics.format;
                self.DestroyReflect();
                self.reflect_buffer = buffer;
                if (buffer != undefined)
                    self.reflect_vbuffer = vertex_create_buffer_from_buffer(buffer, format);
            };
            
            static AutoReflect = function() {
                if (!self.buffer) return false;
                self.DestroyReflect();
                self.reflect_buffer = vertex_to_reflect_buffer(self.buffer);
                self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.format);
                return true;
            };
            
            static Destroy = function() {
                self.DestroyUpright();
                self.DestroyReflect();
            };
            
            static DestroyUpright = function() {
                var valid = !!self.vbuffer;
                if (self.buffer) buffer_delete(self.buffer);
                if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
                self.buffer = undefined;
                self.vbuffer = undefined;
                return valid;
            };
            
            static DestroyReflect = function() {
                var valid = !!self.reflect_vbuffer;
                if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
                if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
                self.reflect_buffer = undefined;
                self.reflect_vbuffer = undefined;
                return valid;
            };
            
            self.Set(buffer);
        };
        
        self.tiles = array_create(AUTOTILE_COUNT);
        for (var i = 0; i < AUTOTILE_COUNT; i++) {
            self.tiles[i] = new MeshVertexBufferData(undefined);
        }
        
        self.Destroy = function() {
            for (var i = 0; i < AUTOTILE_COUNT; i++) {
                self.tiles[i].Destroy();
            }
        };
        
        static LoadAsset = function(filename) {
            for (var i = 0, n = array_length(self.tiles); i < n; i++) {
                self.tiles[i].LoadAsset(filename + "!" + string(i));
            }
        };
        
        static SaveAsset = function(filename) {
            for (var i = 0, n = array_length(self.tiles); i < n; i++) {
                self.tiles[i].SaveAsset(filename + "!" + string(i));
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
    
    static LoadAsset = function(directory) {
        directory += "/" + string_replace_all(self.GUID, ":", "_");
        for (var i = 0, n = array_length(self.layers); i < n; i++) {
            self.layers[i].LoadAsset(directory + "!" + string(i));
        }
    };
    
    static SaveAsset = function(directory) {
        directory += "/" + string_replace_all(self.GUID, ":", "_");
        for (var i = 0, n = array_length(self.layers); i < n; i++) {
            self.layers[i].SaveAsset(directory + "!" + string(i));
        }
    };
}