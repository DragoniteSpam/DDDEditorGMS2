function penguin_load(filename, vertex_format, freeze = true) {
    static HEADER_PRERELEASE = "derg";
    static HEADER_FINAL = "dergxmachina";
    
    static VERSION_PRERELEASE           = 0;
    static VERSION_INITIAL_RELEASE      = 1;
    
    var mesh_cache = { };
    var buffer = -1;
    var version = VERSION_PRERELEASE;
    
    try {
        buffer = buffer_load(filename);
        var header = buffer_read(buffer, buffer_string);
        
        if (header != HEADER_PRERELEASE && header != HEADER_FINAL) {
            throw {
                message: "Bad file header",
                longMessage: string("Expected '{0}' or '{1}', got: {2}", HEADER_PRERELEASE, HEADER_FINAL, header),
                stacktrace: debug_get_callstack(),
                script: penguin_load,
            };
        }
        
        if (header == HEADER_FINAL) {
            version = buffer_read(buffer, buffer_u64);
        }
        
        var textures = { };
        var tex_count = buffer_read(buffer, buffer_u32);
        repeat (tex_count) {
            var name = buffer_read(buffer, buffer_string);
            var guid = buffer_read(buffer, buffer_string);
            if (sprite_get_name(asset_get_index(name)) == name) {
                textures[$ guid] = sprite_get_texture(asset_get_index(name), 0);
            }
        }
        
        var count = buffer_read(buffer, buffer_u32);
        
        repeat (count) {
            var penguin = new Penguin();
            penguin.name = buffer_read(buffer, buffer_string);
            
            buffer_read(buffer, buffer_string);             // internal name
            buffer_read(buffer, buffer_string);             // guid
            buffer_read(buffer, buffer_u64);                // flag
            buffer_read(buffer, buffer_u8);                 // type
            var xmin = buffer_read(buffer, buffer_s16);
            var ymin = buffer_read(buffer, buffer_s16);
            var zmin = buffer_read(buffer, buffer_s16);
            var xmax = buffer_read(buffer, buffer_s16);
            var ymax = buffer_read(buffer, buffer_s16);
            var zmax = buffer_read(buffer, buffer_s16);
            
            buffer_seek(buffer, buffer_seek_relative, (xmax - xmin) * (ymax - ymin) * (zmax - zmin) * buffer_sizeof(buffer_u64));
            
            var submeshes = buffer_read(buffer, buffer_u32);
            penguin.submeshes = array_create(submeshes);
            
            for (var i = 0; i < submeshes; i++) {
                var submesh = new PenguinSubmesh();
                submesh.material = new PenguinMaterial();
                penguin.submeshes[i] = submesh;
                
                submesh.name = buffer_read(buffer, buffer_string);
                buffer_read(buffer, buffer_string);             // guid
                
                submesh.material.diffuse.color = buffer_read(buffer, buffer_u32);
                submesh.material.ambient.color = buffer_read(buffer, buffer_u32);
                submesh.material.specular.color = buffer_read(buffer, buffer_u32);
                submesh.material.specular.exponent = buffer_read(buffer, buffer_f32);
                
                submesh.material.diffuse.tex = textures[$ buffer_read(buffer, buffer_string)] ?? -1;
                submesh.material.normal.tex = textures[$ buffer_read(buffer, buffer_string)] ?? -1;
                submesh.material.ambient.tex = textures[$ buffer_read(buffer, buffer_string)] ?? -1;
                submesh.material.specular.tex = textures[$ buffer_read(buffer, buffer_string)] ?? -1;
                submesh.material.specular.highlight.tex = textures[$ buffer_read(buffer, buffer_string)] ?? -1;
                buffer_read(buffer, buffer_string);             // alpha map
                buffer_read(buffer, buffer_string);             // bump map
                buffer_read(buffer, buffer_string);             // displacement map
                buffer_read(buffer, buffer_string);             // stencil map
                
                var existences = buffer_read(buffer, buffer_u8);
                if (!!((existences >> 1)) & 0x1) {
                    var size = buffer_read(buffer, buffer_u32);
                    var vertex_data = buffer_create(size, buffer_fixed, 1);
                    buffer_copy(buffer, buffer_tell(buffer), size, vertex_data, 0);
                    buffer_seek(buffer, buffer_seek_relative, size);
                    submesh.vbuff = vertex_create_buffer_from_buffer(vertex_data, vertex_format);
                    if (freeze && vertex_get_number(submesh.vbuff) > 0) {
                        vertex_freeze(submesh.vbuff);
                    }
                    buffer_delete(vertex_data);
                }
                if (!!(existences & 0x1)) {
                    var size = buffer_read(buffer, buffer_u32);
                    var vertex_data = buffer_create(size, buffer_fixed, 1);
                    buffer_copy(buffer, buffer_tell(buffer), size, vertex_data, 0);
                    buffer_seek(buffer, buffer_seek_relative, size);
                    submesh.reflect_vbuff = vertex_create_buffer_from_buffer(vertex_data, vertex_format);
                    if (freeze && vertex_get_number(submesh.reflect_vbuff) > 0) {
                        vertex_freeze(submesh.reflect_vbuff);
                    }
                    buffer_delete(vertex_data);
                }
            }
            
            var shape_count = buffer_read(buffer, buffer_u32);
            penguin.collision_shapes = array_create(shape_count);
            
            for (var j = 0; j < shape_count; j++) {
                var type = buffer_read(buffer, buffer_s8);
                var shape_name = "Shape";
                if (version >= VERSION_INITIAL_RELEASE)
                    shape_name = buffer_read(buffer, buffer_string);
                buffer_read(buffer, buffer_u64);                // flag
                var shape = undefined;
                
                switch (type) {
                    case 0:
                        shape = new PenguinCollisionShapeSphere();
                        shape.position.x = buffer_read(buffer, buffer_f32);
                        shape.position.y = buffer_read(buffer, buffer_f32);
                        shape.position.z = buffer_read(buffer, buffer_f32);
                        shape.radius = buffer_read(buffer, buffer_f32);
                        break;
                    case 1:
                        shape = new PenguinCollisionShapeCapsule();
                        shape.position.x = buffer_read(buffer, buffer_f32);
                        shape.position.y = buffer_read(buffer, buffer_f32);
                        shape.position.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.z = buffer_read(buffer, buffer_f32);
                        shape.length = buffer_read(buffer, buffer_f32);
                        shape.radius = buffer_read(buffer, buffer_f32);
                        break;
                    case 2:
                        shape = new PenguinCollisionShapeBox();
                        shape.position.x = buffer_read(buffer, buffer_f32);
                        shape.position.y = buffer_read(buffer, buffer_f32);
                        shape.position.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.x.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.y.z = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.x = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.y = buffer_read(buffer, buffer_f32);
                        shape.orientation.z.z = buffer_read(buffer, buffer_f32);
                        shape.scale.x = buffer_read(buffer, buffer_f32);
                        shape.scale.y = buffer_read(buffer, buffer_f32);
                        shape.scale.z = buffer_read(buffer, buffer_f32);
                        break;
                    case 3:
                        shape = new PenguinCollisionShapeTrimesh();
                        shape.position.x = buffer_read(buffer, buffer_f32);
                        shape.position.y = buffer_read(buffer, buffer_f32);
                        shape.position.z = buffer_read(buffer, buffer_f32);
                        break;
                }
                
                shape.name = shape_name;
                penguin.collision_shapes[j] = shape;
            }
            
            buffer_read(buffer, buffer_bool);               // terrain data - always 0 for .derg files
            
            var n = 0;
            var test_name = penguin.name;
            var warned = false;
            
            while (mesh_cache[$ test_name]) {
                test_name = penguin.name + string(++n);
                if (!warned) {
                    warned = true;
                    show_debug_message("Duplicate mesh found: " + penguin.name + ", appending digits");
                }
            }
            
            penguin.name = test_name;
            mesh_cache[$ penguin.name] = penguin;
        }
    } catch (e) {
        show_message("Couldn't load mesh data: " + e.message + " (" + e.longMessage + ")");
        mesh_cache = { };
    } finally {
        if (buffer_exists(buffer))
            buffer_delete(buffer);
    }
    
    return mesh_cache;
};