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
    
    self.texture_scale = 1;
    
    self.terrain_data = undefined;
    
    self.CopyPropertiesFrom = function(mesh) {
        // cshape is currently NOT copied!
        self.xmin = mesh.xmin;
        self.ymin = mesh.ymin;
        self.zmin = mesh.zmin;
        self.xmax = mesh.xmax;
        self.ymax = mesh.ymax;
        self.zmax = mesh.zmax;
        
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
    
    self.AddSubmesh = function(submesh, proto_guid = undefined) {
        submesh.proto_guid = proto_guid_set(self, array_length(self.submeshes), proto_guid);
        submesh.owner = self;
        array_push(self.submeshes, submesh);
        self.CalculatePhysicalBounds();
        return submesh;
    };
    
    self.AddSubmeshFromFile = function(filename) {
        var data = import_3d_model_generic(filename);
        if (data == undefined) return;
        for (var i = 0, n = array_length(data); i < n; i++) {
            var submesh = new MeshSubmesh("Submesh" + string(array_length(self.submeshes)));
            submesh.SetBufferData(data[i].buffer);
            submesh.path = filename;
            self.AddSubmesh(submesh);
        }
        self.CalculatePhysicalBounds();
    };
    
    self.CalculatePhysicalBounds = function() {
        self.physical_bounds.x1 = infinity;
        self.physical_bounds.y1 = infinity;
        self.physical_bounds.z1 = infinity;
        self.physical_bounds.x2 = -infinity;
        self.physical_bounds.y2 = -infinity;
        self.physical_bounds.z2 = -infinity;
        
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            if (!self.submeshes[i].buffer) continue;
            var sub_bounds = meshops_get_bounds(self.submeshes[i].buffer);
            self.physical_bounds.x1 = min(self.physical_bounds.x1, sub_bounds.x1);
            self.physical_bounds.y1 = min(self.physical_bounds.y1, sub_bounds.y1);
            self.physical_bounds.z1 = min(self.physical_bounds.z1, sub_bounds.z1);
            self.physical_bounds.x2 = max(self.physical_bounds.x2, sub_bounds.x2);
            self.physical_bounds.y2 = max(self.physical_bounds.y2, sub_bounds.y2);
            self.physical_bounds.z2 = max(self.physical_bounds.z2, sub_bounds.z2);
        }
    };
    
    self.AutoCalculateBounds = function() {
        self.CalculatePhysicalBounds();
        
        self.xmin = round(self.physical_bounds.x1 / TILE_WIDTH);
        self.ymin = round(self.physical_bounds.y1 / TILE_HEIGHT);
        self.zmin = round(self.physical_bounds.z1 / TILE_DEPTH);
        self.xmax = round(self.physical_bounds.x2 / TILE_WIDTH);
        self.ymax = round(self.physical_bounds.y2 / TILE_HEIGHT);
        self.zmax = round(self.physical_bounds.z2 / TILE_DEPTH);
        
        self.RecalculateBounds();
    };
    
    self.GenerateReflections = function() {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].GenerateReflections();
        }
    };
    
    self.SwapReflections = function() {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].SwapReflections();
        }
        self.CalculatePhysicalBounds();
    };
    
    #region Actions
    self.BakeDiffuseColor = function() {
        if (self.type == MeshTypes.SMF) return;
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].BakeDiffuseColor();
        }
    };
    
    self.ResetVertexColor = function() {
        if (self.type == MeshTypes.SMF) return;
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].ResetVertexColor();
        }
    };
    
    self.ActionResetDiffuseMaterialColour = function() {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].ActionResetDiffuseMaterialColour();
        }
    };
    
    self.PositionAtCenter = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_transform_center(buffer_get_address(buffer), buffer_get_size(buffer));
        });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionTransform = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBufferParam(function(buffer, data) {
            meshops_transform(buffer_get_address(buffer), buffer_get_size(buffer));
        }, { });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionFloor = function() {
        if (self.type == MeshTypes.SMF) return;
        __meshops_transform_set_matrix(0, 0, -self.physical_bounds.z1, 0, 0, 0, 1, 1, 1);
        self.foreachSubmeshBufferParam(function(buffer, data) {
            meshops_transform(buffer_get_address(buffer), buffer_get_size(buffer));
        }, { });
        self.physical_bounds.z2 -= self.physical_bounds.z1;
        self.physical_bounds.z1 = 0;
    };
    
    self.ActionMirrorX = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_x(buffer_get_address(buffer), buffer_get_size(buffer));
        });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionMirrorY = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_y(buffer_get_address(buffer), buffer_get_size(buffer));
        });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionMirrorZ = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_mirror_axis_z(buffer_get_address(buffer), buffer_get_size(buffer));
        });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionRotateUpAxis = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_rotate_up(buffer_get_address(buffer), buffer_get_size(buffer));
        });
        self.CalculatePhysicalBounds();
    };
    
    self.ActionInvertAlpha = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_invert_alpha(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    self.ActionBakeDiffuseMaterialColor = function() {
        if (self.type == MeshTypes.SMF) return;
        // cant do the foreach here because each baking needs knowledge of the
        // submesh's diffuse material color anyway
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].BakeDiffuseColor();
        }
    };
    
    self.ActionResetAlpha = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_alpha(buffer_get_address(buffer), buffer_get_size(buffer), 1);
        });
    };
    
    self.ActionResetColour = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_color(buffer_get_address(buffer), buffer_get_size(buffer), c_white);
        });
    };
    
    self.ActionFlipTexU = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_flip_tex_u(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    self.ActionFlipTexV = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_flip_tex_v(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    self.ActionNormalsFlat = function() {
        if (self.type == MeshTypes.SMF) return;
        self.foreachSubmeshBuffer(function(buffer) {
            meshops_set_normals_flat(buffer_get_address(buffer), buffer_get_size(buffer));
        });
    };
    
    self.ActionNormalsSmooth = function(threshold) {
        if (self.type == MeshTypes.SMF) return;
        if (self.terrain_data) {
            var buffers = array_create(array_length(self.submeshes));
            var reflections = array_create(array_length(self.submeshes));
            for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
                buffers[i] = self.submeshes[i].buffer;
                reflections[i] = self.submeshes[i].reflect_buffer;
            }
            meshops_set_normals_smooth_multi(buffers, threshold);
            meshops_set_normals_smooth_multi(reflections, threshold);
            for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
                if (self.submeshes[i].buffer) self.submeshes[i].internalSetVertexBuffer();
                if (self.submeshes[i].reflect_buffer) self.submeshes[i].internalSetReflectVertexBuffer();
            }
        } else {
            self.foreachSubmeshBufferParam(function(buffer, threshold) {
                meshops_set_normals_smooth(buffer_get_address(buffer), buffer_get_size(buffer), dcos(threshold));
            }, threshold);
        }
    };
    #endregion
    
    self.Reload = function() {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].Reload();
        }
        self.CalculatePhysicalBounds();
    };
    
    self.RemoveSubmesh = function(index) {
        proto_guid_remove(self, submeshes[index].proto_guid);
        submeshes[index].Destroy();
        array_delete(submeshes, index, 1);
        self.CalculatePhysicalBounds();
    };
    
    self.AddCollisionShape = function(type) {
        var shape = new type();
        array_push(self.collision_shapes, shape);
        return self.collision_shapes[array_length(self.collision_shapes) - 1];
    };
    
    self.RenameCollisionShape = function(index, name) {
        self.collision_shapes[index].name = name;
    }
    
    self.DeleteCollisionShape = function(index) {
        array_delete(self.collision_shapes, index, 1);
    }
    
    self.LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            self.submeshes[i].LoadAsset(directory + guid + "_");
        }
        if (self.terrain_data) self.terrain_data.LoadAsset(directory + guid + "+");
        
        if (!self.physical_bounds) {
            self.physical_bounds = new BoundingBox();
            self.CalculatePhysicalBounds();
        }
    };
    
    self.SaveAsset = function(directory) {
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
        
        var shape_count = array_length(self.collision_shapes);
        buffer_write(buffer, buffer_u32, shape_count);
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
                    /// @todo build a proper orientation matrix here
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, shape.scale.x);
                    buffer_write(buffer, buffer_f32, shape.scale.y);
                    buffer_write(buffer, buffer_f32, shape.scale.z);
                    break;
                case MeshCollisionShapes.CAPSULE:
                    buffer_write(buffer, buffer_f32, shape.rotation.x);
                    buffer_write(buffer, buffer_f32, shape.rotation.y);
                    buffer_write(buffer, buffer_f32, shape.rotation.z);
                    /// @todo build a proper orientation matrix here
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
                    buffer_write(buffer, buffer_f32, 0);
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
        
        var terrain_data_etc = self.terrain_data;
        
        if (IS_MESH_MODE) {
            self.terrain_data = undefined;
        }
        
        buffer_write(buffer, buffer_bool, !!self.terrain_data);
        if (self.terrain_data) self.terrain_data.Export(buffer);
        
        self.terrain_data = terrain_data_etc;
    };
    
    self.CreateJSONMesh = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
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
    
    self.CreateJSON = function() {
        return self.CreateJSONMesh();
    };
    
    self.Destroy = function() {
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
    
    self.RecalculateBounds = function() {
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
    self.foreachSubmeshBuffer = function(f) {
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
    self.foreachSubmeshBufferParam = function(f, arg) {
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
    
    
    if (is_struct(source)) {
        self.type = source.type;
        
        self.texture_scale = source[$ "texture_scale"] ?? NULL;
        
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
            self.physical_bounds = undefined;
        }
    }
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
    /// @todo make a Matrix3/Matrix4 class
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
    /// @todo make a Matrix3/Matrix4 class
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