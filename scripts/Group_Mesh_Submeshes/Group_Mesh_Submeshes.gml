function MeshSubmesh(source) constructor {
    self.buffer = undefined;
    self.vbuffer = undefined;
    self.owner = undefined;
    self.path = "";
    self.proto_guid = NULL;
    
    self.reflect_buffer = undefined;
    self.reflect_vbuffer = undefined;
    
    if (is_struct(source)) {
        self.name = source.name;
        self.path = source.path;
        self.proto_guid = source.proto_guid;
    } else {
        self.name = source;
    }
    
    static LoadAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (file_exists(directory  + proto + ".vertex")) self.buffer = buffer_load(directory  + proto + ".vertex");
        if (file_exists(directory  + proto + ".reflect")) self.reflect_buffer = buffer_load(directory  + proto + ".reflect");
        
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        if (self.reflect_buffer) self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
    };
    
    static SaveAsset = function(directory) {
        var proto = string_replace_all(self.proto_guid, ":", "_");
        if (self.buffer) buffer_save(self.buffer, directory  + proto + ".vertex");
        if (self.reflect_buffer) buffer_save(self.reflect_buffer, directory + proto + ".reflect");
    };
    
    static Export = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_datatype, self.proto_guid);
        var existence = ((!!self.buffer) << 1) | (!!self.reflect_buffer);
        buffer_write(buffer, buffer_u8, existence);
        if (self.buffer) {
            buffer_write(buffer, buffer_u32, buffer_get_size(self.buffer));
            buffer_write_vertex_buffer(buffer, self.buffer);
        }
        if (self.reflect_buffer) {
            buffer_write(buffer, buffer_u32, buffer_get_size(self.reflect_buffer));
            buffer_write_vertex_buffer(buffer, self.reflect_buffer);
        }
    };
    
    static CreateJSON = function() {
        return {
            name: self.name,
            path: self.path,
            proto_guid: self.proto_guid,
        };
    };
    
    static Destroy = function() {
        if (self.buffer) buffer_delete(self.buffer);
        if (self.vbuffer) {
            switch (self.owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(self.vbuffer); break;
            }
        }
        if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
        if (self.reflect_vbuffer) {
            switch (self.owner.type) {
                case MeshTypes.RAW: vertex_delete_buffer(self.reflect_vbuffer); break;
            }
        }
    };
    
    static Clone = function() {
        var cloned_data = new MeshSubmesh(self.name);
        if (self.buffer) {
            cloned_data.buffer = buffer_clone(self.buffer, buffer_fixed, 1);
            cloned_data.vbuffer = vertex_create_buffer_from_buffer(cloned_data.buffer, Stuff.graphics.vertex_format);
        }
        if (self.reflect_buffer) {
            cloned_data.reflect_buffer = buffer_clone(self.reflect_buffer, buffer_fixed, 1);
            cloned_data.reflect_vbuffer = vertex_create_buffer_from_buffer(cloned_data.reflect_buffer, Stuff.graphics.vertex_format);
        }
        cloned_data.path = self.path;
        
        return cloned_data;
    };
    
    static ImportReflection = function() {
        var fn = get_open_filename_mesh();
        if (file_exists(fn)) {
            var data = import_3d_model_generic(fn, false, true, undefined, 0);
            internalDeleteReflect();
            self.reflect_vbuffer = data[0];
            self.reflect_buffer = data[1];
            vertex_freeze(self.reflect_vbuffer);
        }
    };
    
    static GenerateReflections = function() {
        if (!self.buffer) return;
        internalDeleteReflect();
        self.reflect_vbuffer = buffer_to_reflect(self.buffer);
        self.reflect_buffer = buffer_create_from_vertex_buffer(self.reflect_vbuffer, buffer_fixed, 1);
        vertex_freeze(self.reflect_vbuffer);
    };
    
    static SwapReflections = function() {
        var t = self.buffer;
        self.buffer = self.reflect_buffer;
        self.reflect_buffer = t;
        
        t = self.vbuffer;
        self.vbuffer = self.reflect_vbuffer;
        self.reflect_vbuffer = t;
    };
    
    static SetNormalsZero = function() {
        if (self.buffer) {
            internalSetNormalsZero(self.buffer, 1);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsZero(self.reflect_buffer, -1);
            internalSetReflectVertexBuffer();
        }
    };
    
    static SetNormalsFlat = function() {
        if (self.buffer) {
            internalSetNormalsFlat(self.buffer);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsFlat(self.reflect_buffer);
            internalSetReflectVertexBuffer();
        }
    };
    
    static SetNormalsSmooth = function(threshold) {
        if (self.buffer) {
            internalSetNormalsSmooth(self.buffer, threshold);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalSetNormalsSmooth(self.reflect_buffer, threshold);
            internalSetReflectVertexBuffer();
        }
    };
    
    static PositionAtCenter = function() {
        if (self.buffer) {
            internalPositionAtCenter(self.buffer);
            internalSetVertexBuffer();
        }
        if (self.reflect_buffer) {
            internalPositionAtCenter(self.reflect_buffer);
            internalSetReflectVertexBuffer();
        }
    };
    
    static Reload = function() {
        var index = array_search(self.owner.submeshes, self);
        if (file_exists(self.path)) {
            switch (filename_ext(self.path)) {
                case ".obj": import_obj(self.path, undefined, self.owner, index); break;
                case ".d3d": case ".gmmod": import_d3d(self.path, undefined, false, self.owner, index); break;
                case ".smf": break;
            }
        }
    };
    
    static AddBufferData = function(raw_buffer) {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        var new_size = buffer_get_size(raw_buffer);
        if (!self.buffer) {
            self.buffer = buffer_create(new_size, buffer_grow, 1);
        }
        var old_size = buffer_get_size(self.buffer);
        buffer_resize(self.buffer, old_size + new_size);
        buffer_copy(raw_buffer, 0, new_size, self.buffer, old_size);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
        
        if (self.reflect_buffer) {
            buffer_delete(self.reflect_buffer);
            vertex_delete_buffer(self.reflect_vbuffer);
            self.GenerateReflections();
        }
    };
    
    static internalDeleteUpright = function() {
        if (self.buffer) buffer_delete(self.buffer);
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
    };
    
    static internalDeleteReflect = function() {
        if (self.reflect_buffer) buffer_delete(self.reflect_buffer);
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
    };
    
    static internalSetVertexBuffer = function() {
        if (self.vbuffer) vertex_delete_buffer(self.vbuffer);
        self.vbuffer = vertex_create_buffer_from_buffer(self.buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.vbuffer);
    };
    
    static internalSetReflectVertexBuffer = function() {
        if (self.reflect_vbuffer) vertex_delete_buffer(self.reflect_vbuffer);
        self.reflect_vbuffer = vertex_create_buffer_from_buffer(self.reflect_buffer, Stuff.graphics.vertex_format);
        vertex_freeze(self.reflect_vbuffer);
    };
    
    static internalSetNormalsZero = function(buffer, val) {
        buffer_seek(buffer, buffer_seek_start, 0);
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            buffer_poke(buffer, position + VERTEX_SIZE + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE + 20, buffer_f32, val);
            position += VERTEX_SIZE;
        }
    };
    
    static internalSetNormalsFlat = function(buffer) {
        buffer_seek(buffer, buffer_seek_start, 0);
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var normals = triangle_normal(
                // t1
                buffer_peek(buffer, position, buffer_f32),
                buffer_peek(buffer, position + 4, buffer_f32),
                buffer_peek(buffer, position + 8, buffer_f32),
                // t2
                buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
                // t3
                buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32),
            );
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, normals[0]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, normals[1]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, normals[2]);
            
            position += VERTEX_SIZE * 3;
        }
    }
    
    static internalPositionAtCenter = function(buffer) {
        buffer_seek(buffer, buffer_seek_start, 0);
        var position = 0;
        
        var xtotal = 0;
        var ytotal = 0;
        var vertices = buffer_get_size(buffer) / VERTEX_SIZE;
        
        while (position < buffer_get_size(buffer)) {
            xtotal += buffer_peek(buffer, position + 0, buffer_f32);
            ytotal += buffer_peek(buffer, position + 4, buffer_f32);
            position += VERTEX_SIZE;
        }
        
        var xcenter = xtotal / vertices;
        var ycenter = ytotal / vertices;
        position = 0;
        
        while (position < buffer_get_size(buffer)) {
            buffer_poke(buffer, position + 0, buffer_f32, buffer_peek(buffer, position, buffer_f32) - xcenter);
            buffer_poke(buffer, position + 4, buffer_f32, buffer_peek(buffer, position + 4, buffer_f32) - ycenter);
            position += VERTEX_SIZE;
        }
    }
    
    static internalSetNormalsSmooth = function(buffer, threshold) {
        threshold = dcos(threshold);
        internalSetNormalsFlat(buffer);
        
        static triangleKey = function(x, y, z) {
            var p = 3;
            return string_format(x, 1, p) + "," + string_format(y, 1, p) + "," + string_format(z, 1, p);
        };
        
        buffer_seek(buffer, buffer_seek_start, 0);
        var normal_cache = { };
        var position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var xx = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 00, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 00, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 00, buffer_f32)
            ];
            var yy = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 04, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 04, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 04, buffer_f32)
            ];
            var zz = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 08, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 1 + 08, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 08, buffer_f32)
            ];
            var normals = [
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32)
            ];
            
            for (var i = 0; i < 3; i++) {
                var key = triangleKey(xx[i], yy[i], zz[i]);
                if (normal_cache[$ key] != undefined) {
                    var existing = normal_cache[$ key];
                    existing[@ 0] += normals[0];
                    existing[@ 1] += normals[1];
                    existing[@ 2] += normals[2];
                } else {
                    normal_cache[$ key] = normals;
                }
            }
            
            position += VERTEX_SIZE * 3;
        }
        
        position = 0;
        
        while (position < buffer_get_size(buffer)) {
            var xx = buffer_peek(buffer, position + 00, buffer_f32);
            var yy = buffer_peek(buffer, position + 04, buffer_f32);
            var zz = buffer_peek(buffer, position + 08, buffer_f32);
            var nx = buffer_peek(buffer, position + 12, buffer_f32);
            var ny = buffer_peek(buffer, position + 16, buffer_f32);
            var nz = buffer_peek(buffer, position + 20, buffer_f32);
            
            var n = vector3_normalize(normal_cache[$ triangleKey(xx, yy, zz)]);
            if (dot_product_3d(n[0], n[1], n[2], nx, ny, nz) > threshold) {
                buffer_poke(buffer, position + 12, buffer_f32, n[0]);
                buffer_poke(buffer, position + 16, buffer_f32, n[1]);
                buffer_poke(buffer, position + 20, buffer_f32, n[2]);
            }
            
            position += VERTEX_SIZE;
        }
    }
    
    static GetExportedBuffer = function(format_type) {
        if (format_type) {
            static warn_tangent                                                 = 0x01;
            static warn_bitangent                                               = 0x02;
            var warnings = 0;
            
            var format = format_type[? "attributes"];
            var vertex_new_size = 0;
            var attribute_count = 0;
            for (var f = 0, fc = ds_list_size(format); f < fc; f++) {
                var type = format[| f][? "type"];
                attribute_count++;
                switch (type) {
                    // standard
                    case VertexFormatData.POSITION_2D: vertex_new_size += 8; break;
                    case VertexFormatData.POSITION_3D: vertex_new_size += 12; break;
                    case VertexFormatData.NORMAL: vertex_new_size += 12; break;
                    case VertexFormatData.TEXCOORD: vertex_new_size += 8; break;
                    case VertexFormatData.COLOUR: vertex_new_size += 4; break;
                    case VertexFormatData.TANGENT: vertex_new_size += 12; break;
                    case VertexFormatData.BITANGENT: vertex_new_size += 12; break;
                    case VertexFormatData.BARYCENTRIC: vertex_new_size += 12; break;
                    // nonstandard
                    case VertexFormatData.SMALL_NORMAL: vertex_new_size += 4; break;
                    case VertexFormatData.SMALL_TANGENT: vertex_new_size += 4; break;
                    case VertexFormatData.SMALL_BITANGENT: vertex_new_size += 4; break;
                    case VertexFormatData.SMALL_TEXCOORD: vertex_new_size += 4; break;
                    case VertexFormatData.SMALL_NORMAL_PLUS_TEXCOORD: vertex_new_size += 4; break;
                }
            }
            var vertex_count = buffer_get_size(self.buffer) / VERTEX_SIZE;
            var new_size = vertex_count * vertex_new_size;
        
            var base_position = 0;
            var formatted_buffer = buffer_create(new_size, buffer_fixed, 1);
            var current_attribute_count = 0;
            var n_pos = 0;
            var barycentric_index = 0;
            
            // what we're really doing here is looping through each *attribute,*
            // rather than each vertex
            repeat (vertex_count * ds_list_size(format)) {
                var attribute = format[| current_attribute_count++];
                var attribute_type = attribute[? "type"];
                
                switch (attribute_type) {
                    // standard attributes
                    case VertexFormatData.POSITION_2D:
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        break;
                    case VertexFormatData.POSITION_3D:
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 00, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 04, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 08, buffer_f32));
                        break;
                    case VertexFormatData.NORMAL:
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 12, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 16, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 20, buffer_f32));
                        break;
                    case VertexFormatData.TEXCOORD:
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 24, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(self.buffer, base_position + 28, buffer_f32));
                        break;
                    case VertexFormatData.COLOUR:
                        buffer_write(formatted_buffer, buffer_u32, buffer_peek(self.buffer, base_position + 32, buffer_u32));
                        break;
                    case VertexFormatData.TANGENT:
                        warnings |= warn_tangent;
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        break;
                    case VertexFormatData.BITANGENT:
                        warnings |= warn_bitangent;
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        break;
                    case VertexFormatData.BARYCENTRIC:
                        switch (barycentric_index++) {
                            case 0:
                                buffer_write(formatted_buffer, buffer_f32, 1);
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                break;
                            case 1:
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                buffer_write(formatted_buffer, buffer_f32, 1);
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                break;
                            case 2:
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                buffer_write(formatted_buffer, buffer_f32, 0);
                                buffer_write(formatted_buffer, buffer_f32, 1);
                                break;
                        }
                        barycentric_index %= 3;
                        break;
                    // nonstandard attributes
                    case VertexFormatData.SMALL_NORMAL:
                        var nx = floor(buffer_peek(self.buffer, base_position + 12, buffer_f32) / 2 + 0.5 * 255);
                        var ny = floor(buffer_peek(self.buffer, base_position + 16, buffer_f32) / 2 + 0.5 * 255);
                        var nz = floor(buffer_peek(self.buffer, base_position + 20, buffer_f32) / 2 + 0.5 * 255);
                        buffer_write(formatted_buffer, buffer_u32, (nz << 16) | (ny << 8) | nx);
                        break;
                    case VertexFormatData.SMALL_TANGENT:
                        warnings |= warn_tangent;
                        var nx = floor(1 /* to do */ / 2 + 0.5 * 255);
                        var ny = floor(0 /* to do */ / 2 + 0.5 * 255);
                        var nz = floor(0 /* to do */ / 2 + 0.5 * 255);
                        buffer_write(formatted_buffer, buffer_u32, (nz << 16) | (ny << 8) | nx);
                        break;
                    case VertexFormatData.SMALL_BITANGENT:
                        warnings |= warn_bitangent;
                        var nx = floor(0 /* to do */ / 2 + 0.5 * 255);
                        var ny = floor(1 /* to do */ / 2 + 0.5 * 255);
                        var nz = floor(0 /* to do */ / 2 + 0.5 * 255);
                        buffer_write(formatted_buffer, buffer_u32, (nz << 16) | (ny << 8) | nx);
                        break;
                    case VertexFormatData.SMALL_TEXCOORD:
                        var xt = floor(buffer_peek(self.buffer, base_position + 24, buffer_f32) * 255);
                        var yt = floor(buffer_peek(self.buffer, base_position + 28, buffer_f32) * 255);
                        buffer_write(formatted_buffer, buffer_u32, (yt << 8) | xt);
                        break;
                    case VertexFormatData.SMALL_NORMAL_PLUS_TEXCOORD:
                        var nx = floor(buffer_peek(self.buffer, base_position + 12, buffer_f32) / 2 + 0.5 * 255);
                        var ny = floor(buffer_peek(self.buffer, base_position + 16, buffer_f32) / 2 + 0.5 * 255);
                        var nz = floor(buffer_peek(self.buffer, base_position + 20, buffer_f32) / 2 + 0.5 * 255);
                        var xt = floor(buffer_peek(self.buffer, base_position + 24, buffer_f32) * 15);
                        var yt = floor(buffer_peek(self.buffer, base_position + 28, buffer_f32) * 15);
                        var tex = (yt << 4) | xt;
                        buffer_write(formatted_buffer, buffer_u32, (tex << 24) | (nz << 16) | (ny << 8) | nx);
                        break;
                }
                
                if (current_attribute_count == attribute_count) {
                    current_attribute_count = 0;
                    base_position += VERTEX_SIZE;
                }
            }
            
            if (warnings & warn_tangent) {
                wtf("To do: calculate tangent vectors when exporting a mesh with a vertex format using the tangent vector");
            }
            if (warnings & warn_bitangent) {
                wtf("To do: calculate bitangent vectors when exporting a mesh with a vertex format using the bitangent vector");
            }
            
            return formatted_buffer;
        }
        
        return self.buffer;
    };
}