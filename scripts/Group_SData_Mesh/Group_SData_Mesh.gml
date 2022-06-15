function DataMesh(source) : SData(source) constructor {
    self.type = MeshTypes.RAW;
    
    self.submeshes = [];
    
    self.proto_guids = { };
    self.proto_guid_current = 0;
    self.first_proto_guid = NULL;
    
    self.collision_shapes = [];
    
    /* s */ self.xmin = 0;
    /* s */ self.ymin = 0;
    /* s */ self.zmin = 0;
    /* s */ self.xmax = 1;
    /* s */ self.ymax = 1;
    /* s */ self.zmax = 1;
    
    /* s */ self.asset_flags = [[[0]]];
    
    self.physical_bounds = new BoundingBox(0, 0, 0, 0, 0, 0);
    
    self.use_independent_bounds = Game.meta.extra.mesh_use_independent_bounds_default;
    
    self.tex_base = NULL;                    // map_Kd
    self.tex_ambient = NULL;                 // map_Ka
    self.tex_specular_color = NULL;          // map_Ls
    self.tex_specular_highlight = NULL;      // map_Ns
    self.tex_alpha = NULL;                   // map_d
    self.tex_bump = NULL;                    // map_bump
    self.tex_displacement = NULL;            // disp
    self.tex_stencil = NULL;                 // decal
    
    self.texture_scale = 1;
    
    self.terrain_data = undefined;
    
    if (is_struct(source)) {
        self.type = source.type;
        self.tex_base = source.tex_base;
        self.tex_ambient = source.tex_ambient;
        self.tex_specular_color = source.tex_specular_color;
        self.tex_specular_highlight = source.tex_specular_highlight;
        self.tex_alpha = source.tex_alpha;
        self.tex_bump = source.tex_bump;
        self.tex_displacement = source.tex_displacement;
        self.tex_stencil = source.tex_stencil;
        self.texture_scale = source.texture_scale;
        
        self.asset_flags = source.asset_flags;
        self.xmin = source.xmin;
        self.ymin = source.ymin;
        self.zmin = source.zmin;
        self.xmax = source.xmax;
        self.ymax = source.ymax;
        self.zmax = source.zmax;
        
        for (var i = 0; i < array_length(source.submeshes); i++) {
            self.AddSubmesh(new MeshSubmesh(source.submeshes[i]), source.submeshes[i].proto_guid);
        }
        
        try {
            self.collision_shapes = source.collision_shapes;
        } catch (e) {
            self.collision_shapes = [];
        }
        
        try {
            self.terrain_data = new MeshTerrainData(source.terrain_data.w, source.terrain_data.h, 0);
            self.terrain_data.Load(source);
        } catch (e) {
            self.terrain_data = undefined;
        }
        
        self.use_independent_bounds = source[$ "use_independent_bounds"] ?? self.use_independent_bounds;
        
        try {
            self.physical_bounds.x1 = source.physical_bounds.x1;
            self.physical_bounds.y1 = source.physical_bounds.y1;
            self.physical_bounds.z1 = source.physical_bounds.z1;
            self.physical_bounds.x2 = source.physical_bounds.x2;
            self.physical_bounds.y2 = source.physical_bounds.y2;
            self.physical_bounds.z2 = source.physical_bounds.z2;
        } catch (e) {
            self.physical_bounds.x1 = 0;
            self.physical_bounds.y1 = 0;
            self.physical_bounds.z1 = 0;
            self.physical_bounds.x2 = 0;
            self.physical_bounds.y2 = 0;
            self.physical_bounds.z2 = 0;
        }
    }
    
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
        
        self.use_independent_bounds = mesh.use_independent_bounds;
        
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
        
        self.collision_shapes = json_parse(json_stringify(mesh.collision_shapes));
    };
    
    static AddSubmesh = function(submesh, proto_guid = undefined) {
        submesh.proto_guid = proto_guid_set(self, array_length(self.submeshes), proto_guid);
        submesh.owner = self;
        array_push(self.submeshes, submesh);
        return submesh;
    };
    
    static AddSubmeshFromFile = function(filename) {
        var data = import_3d_model_generic(filename);
        if (data == undefined) return;
        for (var i = 0, n = array_length(data); i < n; i++) {
            var submesh = new MeshSubmesh("Submesh" + string(array_length(self.submeshes)));
            submesh.SetBufferData(data[i]);
            self.AddSubmesh(submesh);
        }
    };
    
    self.CalculatePhysicalBounds = function() {
        self.physical_bounds.x1 = infinity;
        self.physical_bounds.y1 = infinity;
        self.physical_bounds.z1 = infinity;
        self.physical_bounds.x2 = -infinity;
        self.physical_bounds.y2 = -infinity;
        self.physical_bounds.z2 = -infinity;
        
        for (var i = 0; i < array_length(self.submeshes); i++) {
            if (!self.submeshes[i].buffer) continue;
            var sub_bounds = meshops_get_bounds(self.submeshes[i].buffer);
            self.physical_bounds.x1 = min(self.physical_bounds.x1, sub_bounds.x1);
            self.physical_bounds.y1 = min(self.physical_bounds.y1, sub_bounds.y1);
            self.physical_bounds.z1 = min(self.physical_bounds.z1, sub_bounds.y1);
            self.physical_bounds.x2 = max(self.physical_bounds.x2, sub_bounds.x2);
            self.physical_bounds.y2 = max(self.physical_bounds.y2, sub_bounds.y2);
            self.physical_bounds.z2 = max(self.physical_bounds.z2, sub_bounds.z2);
        }
    };
    
    static AutoCalculateBounds = function() {
        self.CalculatePhysicalBounds();
        
        self.xmin = round(self.physical_bounds.x1 / TILE_WIDTH);
        self.ymin = round(self.physical_bounds.y1 / TILE_HEIGHT);
        self.zmin = round(self.physical_bounds.z1 / TILE_DEPTH);
        self.xmax = round(self.physical_bounds.x2 / TILE_WIDTH);
        self.ymax = round(self.physical_bounds.y2 / TILE_HEIGHT);
        self.zmax = round(self.physical_bounds.z2 / TILE_DEPTH);
        
        self.RecalculateBounds();
    };
    
    static GenerateReflections = function() {
        for (var i = 0; i < array_length(submeshes); i++) {
            submeshes[i].GenerateReflections();
        }
    };
    
    static SwapReflections = function() {
        for (var i = 0; i < array_length(submeshes); i++) {
            submeshes[i].SwapReflections();
        }
    };
    
    #region Actions
    static PositionAtCenter = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_transform_center(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionTransform = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBufferParam(function(buffer, data) {
            meshops_transform(buffer_get_address(buffer), buffer_get_size(buffer));
        }, { });
    };
    
    static ActionMirrorX = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_x(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionMirrorY = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_y(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionMirrorZ = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_z(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionRotateUpAxis = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_rotate_up(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionInvertAlpha = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_invert_alpha(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionResetAlpha = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_alpha(buffer_get_address(buffer), buffer_get_size(buffer), 1);
        });
    };
    
    static ActionResetColour = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_color(buffer_get_address(buffer), buffer_get_size(buffer), c_white);
        });
    };
    
    static ActionFlipTexU = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_flip_tex_u(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionFlipTexV = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_flip_tex_v(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionNormalsFlat = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_normals_flat(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    static ActionNormalsSmooth = function(threshold) {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBufferParam(function(buffer, threshold) {
            meshops_set_normals_smooth(buffer_get_address(buffer), buffer_get_size(buffer), dcos(threshold));
        }, threshold);
    };
    #endregion
    
    static Reload = function() {
        for (var i = 0; i < array_length(submeshes); i++) {
            submeshes[i].Reload();
        }
    };
    
    static RemoveSubmesh = function(index) {
        proto_guid_remove(self, submeshes[index].proto_guid);
        submeshes[index].Destroy();
        array_delete(submeshes, index, 1);
    };
    
    static AddCollisionShape = function(type) {
        var shape = new type();
        array_push(self.collision_shapes, shape);
        return self.collision_shapes[array_length(self.collision_shapes) - 1];
    };
    
    static RenameCollisionShape = function(index, name) {
        self.collision_shapes[index].name = name;
    }
    
    static DeleteCollisionShape = function(index) {
        array_delete(self.collision_shapes, index, 1);
    }
    
    static LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].LoadAsset(directory + guid + "_");
        }
        if (self.terrain_data) self.terrain_data.LoadAsset(directory + guid + "+");
    };
    
    static SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].SaveAsset(directory + guid + "_");
        }
        if (self.terrain_data) self.terrain_data.SaveAsset(directory + guid + "+");
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u8, self.type);
        buffer_write(buffer, buffer_datatype, self.tex_base);
        buffer_write(buffer, buffer_datatype, self.tex_ambient);
        buffer_write(buffer, buffer_datatype, self.tex_specular_color);
        buffer_write(buffer, buffer_datatype, self.tex_specular_highlight);
        buffer_write(buffer, buffer_datatype, self.tex_alpha);
        buffer_write(buffer, buffer_datatype, self.tex_bump);
        buffer_write(buffer, buffer_datatype, self.tex_displacement);
        buffer_write(buffer, buffer_datatype, self.tex_stencil);
        buffer_write(buffer, buffer_s16, self.xmin);
        buffer_write(buffer, buffer_s16, self.ymin);
        buffer_write(buffer, buffer_s16, self.zmin);
        buffer_write(buffer, buffer_s16, self.xmax);
        buffer_write(buffer, buffer_s16, self.ymax);
        buffer_write(buffer, buffer_s16, self.zmax);
        for (var i = 0, n = array_length(self.asset_flags); i < n; i++) {
            for (var j = 0, n2 = array_length(self.asset_flags[i]); j < n2; j++) {
                for (var k = 0, n3 = array_length(self.asset_flags[i][j]); k < n3; k++) {
                    buffer_write(buffer, buffer_flag, self.asset_flags[i][j][k]);
                }
            }
        }
        buffer_write(buffer, buffer_u32, array_length(self.submeshes));
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].Export(buffer);
        }
        
        if (Game.meta.export.flags & GameExportFlags.COLLISION_SHAPES) {
            buffer_write(buffer, buffer_u32, array_length(self.collision_shapes));
            for (var i = 0, n = array_length(self.collision_shapes); i < n; i++) {
                var shape = self.collision_shapes[i];
                buffer_write(buffer, buffer_s8, shape.type);
                buffer_write(buffer, buffer_flag, shape.asset_flags);
                buffer_write(buffer, buffer_f32, shape.position.x);
                buffer_write(buffer, buffer_f32, shape.position.y);
                buffer_write(buffer, buffer_f32, shape.position.z);
                switch (shape.type) {
                    case MeshCollisionShapes.BOX:
                        buffer_write(buffer, buffer_f32, shape.rotation.x);
                        buffer_write(buffer, buffer_f32, shape.rotation.y);
                        buffer_write(buffer, buffer_f32, shape.rotation.z);
                        buffer_write(buffer, buffer_f32, shape.scale.x);
                        buffer_write(buffer, buffer_f32, shape.scale.y);
                        buffer_write(buffer, buffer_f32, shape.scale.z);
                        break;
                    case MeshCollisionShapes.CAPSULE:
                        buffer_write(buffer, buffer_f32, shape.rotation.x);
                        buffer_write(buffer, buffer_f32, shape.rotation.y);
                        buffer_write(buffer, buffer_f32, shape.rotation.z);
                        buffer_write(buffer, buffer_f32, shape.length);
                        buffer_write(buffer, buffer_f32, shape.radius);
                        break;
                    case MeshCollisionShapes.SPHERE:
                        buffer_write(buffer, buffer_f32, shape.radius);
                        break;
                    case MeshCollisionShapes.TRIMESH:
                        break;
                }
            }
        }
        
        buffer_write(buffer, buffer_bool, !!self.terrain_data);
        if (self.terrain_data) self.terrain_data.Export(buffer);
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
        
        json.use_independent_bounds = self.use_independent_bounds;
        
        json.asset_flags = self.asset_flags;
        json.xmin = self.xmin;
        json.ymin = self.ymin;
        json.zmin = self.zmin;
        json.xmax = self.xmax;
        json.ymax = self.ymax;
        json.zmax = self.zmax;
        
        json.submeshes = array_create(array_length(self.submeshes));
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            json.submeshes[i] = self.submeshes[i].CreateJSON();
        }
        
        json.collision_shapes = self.collision_shapes;
        
        if (self.terrain_data) json.terrain_data = self.terrain_data.Save();
        
        json.physical_bounds = self.physical_bounds;
        
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONMesh();
    };
    
    static Destroy = function() {
        self.DestroyBase();
        
        if (self.terrain_data) self.terrain_data.Destroy();
        
        for (var i = 0; i < array_length(self.submeshes); i++) {
            self.submeshes[i].Destroy();
        }
        
        var map = Stuff.map.active_map;
        for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
            var thing = map.contents.all_entities[| i];
            if (thing.etype == ETypes.ENTITY_MESH && thing.mesh == self.GUID) {
                editor_map_mark_changed(thing);
            }
        }
        
        var list_index = array_search(Game.meshes, self);
        if (list_index != -1) {
            array_delete(Game.meshes, list_index, 1);
        } else {
            list_index = array_search(Game.mesh_terrain, self);
            array_delete(Game.mesh_terrain, list_index, 1);
        }
    };
    
    static RecalculateBounds = function() {
        var xx = self.xmax - self.xmin;
        var yy = self.ymax - self.ymin;
        var zz = self.zmax - self.zmin;
        array_resize(self.asset_flags, xx);
        for (var i = 0; i < xx; i++) {
            if (!is_array(self.asset_flags[i])) {
                self.asset_flags[@ i] = array_create(yy);
            } else {
                array_resize(self.asset_flags[@ i], yy);
            }
            for (var j = 0; j < yy; j++) {
                if (!is_array(self.asset_flags[i][j])) {
                    self.asset_flags[@ i][@ j] = array_create(zz);
                } else {
                    array_resize(self.asset_flags[@ i][@ j], zz);
                }
            }
        }
    };
    
    /// @ignore
    static foreachSubmeshBuffer = function(f) {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            var submesh = self.submeshes[i];
            f(submesh.buffer);
            submesh.internalSetVertexBuffer();
            if (submesh.reflect_buffer) {
                f(submesh.reflect_buffer);
                submesh.internalSetReflectVertexBuffer();
            }
        }
    };
    
    /// @ignore
    static foreachSubmeshBufferParam = function(f, arg) {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            var submesh = self.submeshes[i];
            f(submesh.buffer, arg);
            submesh.internalSetVertexBuffer();
            if (submesh.reflect_buffer) {
                f(submesh.reflect_buffer, arg);
                submesh.internalSetReflectVertexBuffer();
            }
        }
    };
}

// if you give these methods or anything you're going to have to write
// json-serializing code go go with it when you save
function MeshCollisionShape() constructor {
    self.name = "shape";
    self.position = new Vector3(0, 0, 0);
    self.asset_flags = 0xffffffff;
    self.type = -1;
}

function MeshCollisionShapeBox() : MeshCollisionShape() constructor {
    self.name = "Box";
    self.rotation = new Vector3(0, 0, 0);
    self.scale = new Vector3(1, 1, 1);
    self.type = MeshCollisionShapes.BOX;
}

function MeshCollisionShapeSphere() : MeshCollisionShape() constructor {
    self.name = "Sphere";
    self.radius = 1;
    self.type = MeshCollisionShapes.SPHERE;
}

function MeshCollisionShapeCapsule() : MeshCollisionShape() constructor {
    self.name = "Capsule";
    self.rotation = new Vector3(0, 0, 0);
    self.radius = 1;
    self.length = 4;
    self.type = MeshCollisionShapes.CAPSULE;
}

function MeshCollisionShapeTrimesh() : MeshCollisionShape() constructor {
    self.name = "Trimesh";
    self.triangles = [];
    self.type = MeshCollisionShapes.TRIMESH;
    // implement the trimesh later
}

function MeshTerrainData(w, h, heightmap) constructor {
    self.w = w;
    self.h = h;
    self.heightmap = heightmap;
    self.min_height = 0;
    self.max_height = 0;
    
    self.Sample = function(x, y) {
        return buffer_sample_pixel(self.heightmap, x, y, self.w, self.h, buffer_f32);
    };
    
    self.Destroy = function() {
        buffer_delete(self.heightmap);
    };
    
    self.Save = function() {
        return {
            h: self.h,
            w: self.w,
            min_height: self.min_height,
            max_height: self.max_height,
        };
    };
    
    self.Load = function(source) {
        self.min_height = source[$ "min_height"];
        self.max_height = source[$ "max_height"];
    };
    
    self.SaveAsset = function(directory) {
        buffer_save(self.heightmap, directory + ".hm");
    };
    
    self.LoadAsset = function(directory) {
        self.heightmap = buffer_load(directory + ".hm");
        
        // validate the min and max height of the terrain
        if(self.min_height == undefined || self.max_height == undefined) {
            self.min_height = infinity;
            self.max_height = -infinity;
            for (var i = 0, n = buffer_get_size(self.heightmap); i < n; i += buffer_sizeof(buffer_f32)) {
                var z = buffer_peek(self.heightmap, i, buffer_f32);
                self.min_height = min(self.min_height, z);
                self.max_height = max(self.max_height, z);
            }
        }
    };
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_u32, self.w);
        buffer_write(buffer, buffer_u32, self.h);
        buffer_write(buffer, buffer_f32, self.min_height);
        buffer_write(buffer, buffer_f32, self.max_height);
        buffer_write_buffer(buffer, self.heightmap);
    };
}

enum MeshTypes {
    RAW,
    SMF
}

enum MeshFlags {
    PARTICLE            = 0x0001,
    AUTO_STATIC         = 0x0002,
}

enum MeshTextureSlots {
    BASE, AMBIENT, SPEC_COLOR, SPEC_HIGHLIGHT, ALPHA, BUMP, DISPLACEMENT, STENCIL,
    _COUNT
}

enum MeshCollisionShapes {
    SPHERE,
    CAPSULE,
    BOX,
    TRIMESH,
}