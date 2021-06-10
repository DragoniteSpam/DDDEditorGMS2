function DataMesh(name) : SData(name) constructor {
    self.type = MeshTypes.RAW;
    
    self.submeshes = ds_list_create();
    // there will only be one collision shape, defined as the first mesh
    // you import; this is a good reason to make all meshes in a series
    // the same shape, or almost the same shape
    self.cshape = noone;
    
    self.proto_guids = { };
    self.proto_guid_current = 0;
    self.first_proto_guid = NULL;
    
    /* s */ self.xmin = 0;
    /* s */ self.ymin = 0;
    /* s */ self.zmin = 0;
    /* s */ self.xmax = 1;
    /* s */ self.ymax = 1;
    /* s */ self.zmax = 1;
    
    /* s */ self.asset_flags = [[[0]]];
    
    self.tex_base = NULL;                    // map_Kd
    self.tex_ambient = NULL;                 // map_Ka
    self.tex_specular_color = NULL;          // map_Ls
    self.tex_specular_highlight = NULL;      // map_Ns
    self.tex_alpha = NULL;                   // map_d
    self.tex_bump = NULL;                    // map_bump
    self.tex_displacement = NULL;            // disp
    self.tex_stencil = NULL;                 // decal
    
    self.texture_scale = 1;
    
    self.CopyPropertiesFrom = function(mesh) {
        // cshape is currently NOT copied!
        
        self.xmin = mesh.xmin;
        self.ymin = mesh.ymin;
        self.zmin = mesh.zmin;
        self.xmax = mesh.xmax;
        self.ymax = mesh.ymax;
        self.zmax = mesh.zmax;
        
        self.tex_base = mesh.tex_base;
        self.tex_ambient = mesh.tex_ambient;
        self.tex_specular_color = mesh.tex_specular_color;
        self.tex_specular_highlight = mesh.tex_specular_highlight;
        self.tex_alpha = mesh.tex_alpha;
        self.tex_bump = mesh.tex_bump;
        self.tex_displacement = mesh.tex_displacement;
        self.tex_stencil = mesh.tex_stencil;
        self.texture_scale = mesh.texture_scale;
        
        var hh = abs(mesh.xmax - mesh.xmin);
        var ww = abs(mesh.ymax - mesh.ymin);
        var dd = abs(mesh.zmax - mesh.zmin);
        
        self.asset_flags = array_create(hh);
        for (var i = 0; i < hh; i++) {
            self.asset_flags[i] = array_create(ww);
            for (var j = 0; j < ww; j++) {
                self.asset_flags[i][j] = array_create(dd);
                for (var k = 0; k < dd; k++) {
                    self.asset_flags[i][j][k] = mesh.asset_flags[i][j][k];
                }
            }
        }
    };
    
    static AddSubmesh = function(submesh, proto_guid) {
        submesh.proto_guid = proto_guid_set(self, ds_list_size(self.submeshes), proto_guid);
        submesh.owner = self;
        ds_list_add(self.submeshes, submesh);
        return submesh;
    };
    
    static AutoCalculateBounds = function() {
        self.xmin = infinity;
        self.ymin = infinity;
        self.zmin = infinity;
        self.xmax = -infinity;
        self.ymax = -infinity;
        self.zmax = -infinity;
        
        for (var i = 0; i < ds_list_size(self.submeshes); i++) {
            var sub = self.submeshes[| i];
            buffer_seek(sub.buffer, buffer_seek_start, 0);
            
            while (buffer_tell(sub.buffer) < buffer_get_size(sub.buffer)) {
                var xx = round(buffer_read(sub.buffer, buffer_f32) / TILE_WIDTH);
                var yy = round(buffer_read(sub.buffer, buffer_f32) / TILE_HEIGHT);
                var zz = round(buffer_read(sub.buffer, buffer_f32) / TILE_DEPTH);
                buffer_seek(sub.buffer, buffer_seek_relative, VERTEX_SIZE - 12);
                self.xmin = min(self.xmin, xx);
                self.ymin = min(self.ymin, yy);
                self.zmin = min(self.zmin, zz);
                self.xmax = max(self.xmax, xx);
                self.ymax = max(self.ymax, yy);
                self.zmax = max(self.zmax, zz);
            }
            
            buffer_seek(sub.buffer, buffer_seek_start, 0);
        }
        
        data_mesh_recalculate_bounds(self);
    };
    
    static GenerateReflections = function() {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].GenerateReflections();
        }
    };
    
    static SetNormalsZero = function() {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].SetNormalsZero();
        }
    };
    
    static SetNormalsFlat = function() {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].SetNormalsFlat();
        }
    };
    
    static SetNormalsSmooth = function(threshold) {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].SetNormalsSmooth(threshold);
        }
    };
    
    static SwapReflections = function() {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].SwapReflections();
        }
    };
    
    static Reload = function() {
        for (var i = 0; i < ds_list_size(submeshes); i++) {
            submeshes[| i].Reload();
        }
    };
    
    static RemoveSubmesh = function(index) {
        proto_guid_remove(self, submeshes[| index].proto_guid);
        submeshes[| index].Destroy();
        ds_list_delete(submeshes, index);
    };
    
    static LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        for (var i = 0, n = ds_list_size(self.submeshes); i < n; i++) {
            self.submeshes[| i].LoadAsset(directory + guid + "_");
        }
    };
    
    static SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        for (var i = 0, n = ds_list_size(self.submeshes); i < n; i++) {
            self.submeshes[| i].SaveAsset(directory + guid + "_");
        }
    };
    
    static LoadJSONMesh = function(json) {
        self.LoadJSONBase(json);
        self.type = json.type;
        self.tex_base = json.tex_base;
        self.tex_ambient = json.tex_ambient;
        self.tex_specular_color = json.tex_specular_color;
        self.tex_specular_highlight = json.tex_specular_highlight;
        self.tex_alpha = json.tex_alpha;
        self.tex_bump = json.tex_bump;
        self.tex_displacement = json.tex_displacement;
        self.tex_stencil = json.tex_stencil;
        self.texture_scale = json.texture_scale;
        
        self.asset_flags = json.asset_flags;
        self.xmin = json.xmin;
        self.ymin = json.ymin;
        self.zmin = json.zmin;
        self.xmax = json.xmax;
        self.ymax = json.ymax;
        self.zmax = json.zmax;
        
        for (var i = 0; i < array_length(json.submeshes); i++) {
            var submesh = new MeshSubmesh();
            submesh.LoadJSON(json.submeshes[i]);
            ds_list_add(self.submeshes, submesh);
        }
    };
    
    static LoadJSON = function(json) {
        self.LoadJSONMesh(json);
    };
    
    static CreateJSONMesh = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
        json.tex_base = self.tex_base;
        json.tex_ambient = self.tex_ambient;
        json.tex_specular_color = self.tex_specular_color;
        json.tex_specular_highlight = self.tex_specular_highlight;
        json.tex_alpha = self.tex_alpha;
        json.tex_bump = self.tex_bump;
        json.tex_displacement = self.tex_displacement;
        json.tex_stencil = self.tex_stencil;
        json.texture_scale = self.texture_scale;
        
        json.asset_flags = self.asset_flags;
        json.xmin = self.xmin;
        json.ymin = self.ymin;
        json.zmin = self.zmin;
        json.xmax = self.xmax;
        json.ymax = self.ymax;
        json.zmax = self.zmax;
        
        json.submeshes = array_create(ds_list_size(self.submeshes));
        for (var i = 0, n = ds_list_size(self.submeshes); i < n; i++) {
            json.submeshes[i] = self.submeshes[| i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMesh();
    };
    
    static Destroy = function() {
        self.DestroyBase();
        
        var map = Stuff.map.active_map;

        for (var i = 0; i < ds_list_size(self.submeshes); i++) {
            self.submeshes[| i].Destroy();
        }
        
        for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
            var thing = map.contents.all_entities[| i];
            if (instanceof_classic(thing, EntityMesh) && thing.mesh == self.GUID) {
                c_world_destroy_object(thing.cobject);
                thing.cobject = c_object_create_cached(Stuff.graphics.c_shape_block, CollisionMasks.MAIN, CollisionMasks.MAIN);
                thing.SetCollisionTransform();
                editor_map_mark_changed(thing);
            }
        }
        
        ds_list_delete(Game.meshes, ds_list_find_index(Game.meshes, self));
    };
}

enum MeshTypes {
    RAW,
    SMF
}

enum MeshFlags {
    PARTICLE            = 0x0001,
    SILHOUETTE          = 0x0002,
}