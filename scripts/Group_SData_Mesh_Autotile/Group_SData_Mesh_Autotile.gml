function DataMeshAutotile(source) : SData(source) constructor {
    static MeshAutotileLayer = function() constructor {
        static MeshVertexBufferData = function(buffer, vbuffer) constructor {
            self.buffer = undefined;
            self.vbuffer = undefined;
            self.wbuffer = undefined;
            self.wrawbuffer = undefined;
            self.reflect_buffer = undefined;
            self.reflect_vbuffer = undefined;
            self.reflect_wbuffer = undefined;
            self.reflect_wrawbuffer = undefined;
            
            static LoadAsset = function(filename) {
                self.DestroyUpright();
                self.DestroyReflect();
                // not all of these may exist
                if (file_exists(filename + ".vertex")) self.buffer = buffer_load(filename + ".vertex");
                if (file_exists(filename + ".reflect")) self.reflect_buffer = buffer_load(filename + ".reflect");
                if (file_exists(filename + ".wire")) self.wrawbuffer = buffer_load(filename + ".wire");
                if (file_exists(filename + ".rwire")) self.reflect_wrawbuffer = buffer_load(filename + ".rwire");
                try { self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format); } catch (e) { }
                try { self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format); } catch (e) { }
                try { self.wbuffer = vertex_create_buffer_from_buffer(self.wrawbuffer, Stuff.graphics.vertex_format); } catch (e) { }
                try { self.reflect_wbuffer = vertex_create_buffer_from_buffer(self.reflect_wrawbuffer, Stuff.graphics.vertex_format); } catch (e) { }
            };
            
            static SaveAsset = function(filename) {
                if (self.buffer) buffer_save(self.buffer, filename + ".vertex");
                if (self.reflect_buffer) buffer_save(self.reflect_buffer, filename + ".reflect");
                if (self.wrawbuffer) buffer_save(self.wrawbuffer, filename + ".wire");
                if (self.reflect_wrawbuffer) buffer_save(self.reflect_wrawbuffer, filename + ".rwire");
            };
            
            static Set = function(buffer, vbuffer) {
                self.DestroyUpright();
                self.buffer = buffer;
                self.vbuffer = vbuffer;
                if (buffer) {
                    self.wbuffer = buffer_to_wireframe(buffer);
                    self.wrawbuffer = buffer_create_from_vertex_buffer(self.wbuffer, buffer_fixed, 1);
                }
            };
            
            static SetReflect = function(buffer, vbuffer) {
                self.DestroyReflect();
                self.reflect_buffer = buffer;
                self.reflect_vbuffer = vbuffer;
                if (buffer) self.reflect_wbuffer = buffer_to_wireframe(buffer);
            };
            
            static AutoReflect = function() {
                if (!self.buffer) return false;
                self.DestroyReflect();
                self.reflect_vbuffer = buffer_to_reflect(self.buffer);
                self.reflect_buffer = buffer_create_from_vertex_buffer(self.reflect_vbuffer, buffer_fixed, 1);
                self.reflect_wbuffer = buffer_to_wireframe(self.reflect_buffer);
                self.reflect_wrawbuffer = buffer_create_from_vertex_buffer(self.reflect_wbuffer, buffer_fixed, 1);
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
                if (self.wbuffer) vertex_delete_buffer(self.wbuffer);
                if (self.wrawbuffer) vertex_delete_buffer(self.wrawbuffer);
                self.buffer = undefined;
                self.vbuffer = undefined;
                self.wbuffer = undefined;
                self.wrawbuffer = undefined;
                return valid;
            };
            
            static DestroyReflect = function() {
                var valid = !!self.reflect_vbuffer;
                if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
                if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
                if (self.reflect_wbuffer) vertex_delete_buffer(self.reflect_wbuffer);
                if (self.reflect_wrawbuffer) vertex_delete_buffer(self.reflect_wrawbuffer);
                self.reflect_buffer = undefined;
                self.reflect_vbuffer = undefined;
                self.reflect_wbuffer = undefined;
                self.reflect_wrawbuffer = undefined;
                return valid;
            };
            
            self.Set(buffer, vbuffer);
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