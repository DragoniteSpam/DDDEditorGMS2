function terrain_set_normals(terrain, x, y) {
    var smooth = true;
    var threshold = 0.3;
    var normal_map = { };
    var source_vertices = { };
    
    if (x > 0 && y > 0) {
        #region northwest
        var index_nw_a = [
            terrain_get_vertex_index(terrain, x - 1, y - 1, 0),
            terrain_get_vertex_index(terrain, x - 1, y - 1, 1),
            terrain_get_vertex_index(terrain, x - 1, y - 1, 2),
        ];
        
        var index_nw_b = [
            terrain_get_vertex_index(terrain, x - 1, y - 1, 3),
            terrain_get_vertex_index(terrain, x - 1, y - 1, 4),
            terrain_get_vertex_index(terrain, x - 1, y - 1, 5),
        ];
        
        var values_nw_a = [
            buffer_peek(terrain.terrain_buffer_data, index_nw_a[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_nw_a[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_nw_a[2] + 8, buffer_f32),
        ];
        
        var values_nw_b = [
            buffer_peek(terrain.terrain_buffer_data, index_nw_b[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_nw_b[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_nw_b[2] + 8, buffer_f32),
        ];
        
        var normal_nw_a =   triangle_normal(x - 1, y - 1, values_nw_a[0], x,     y - 1, values_nw_a[1], x,     y,     values_nw_a[2]);
        var normal_nw_b =   triangle_normal(x,     y,     values_nw_b[0], x - 1, y,     values_nw_b[1], x - 1, y - 1, values_nw_b[2]);
        
        if (smooth) {
            var normals = [normal_nw_a, normal_nw_a, normal_nw_a, normal_nw_b, normal_nw_b, normal_nw_b];
            
            var vertices = [
                [x - 1, y - 1, values_nw_a[0], index_nw_a[0]], [x, y - 1, values_nw_a[1], index_nw_a[1]], [x, y, values_nw_a[2], index_nw_a[2]],
                [x, y, values_nw_b[0], index_nw_b[0]], [x - 1, y, values_nw_b[1], index_nw_b[1]], [x - 1, y - 1, values_nw_b[2], index_nw_b[2]]
            ];
            
            for (var i = 0; i < 6; i++) {
                var normal = normals[i];
                var vertex = vertices[i];
                var key = string(vertex);
                if (source_vertices[$ key] == undefined) source_vertices[$ key] = vertex;
                if (normal_map[$ key] == undefined) {
                    normal_map[$ key] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
                } else {
                    var sN = normal_map[$ key];
                    normal_map[$ key] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
                }
            }
        } else {
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[0] + 12, buffer_f32, normal_nw_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[0] + 16, buffer_f32, normal_nw_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[0] + 20, buffer_f32, normal_nw_a[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[1] + 12, buffer_f32, normal_nw_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[1] + 16, buffer_f32, normal_nw_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[1] + 20, buffer_f32, normal_nw_a[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[2] + 12, buffer_f32, normal_nw_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[2] + 16, buffer_f32, normal_nw_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_a[2] + 20, buffer_f32, normal_nw_a[vec3.zz]);
            
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[0] + 12, buffer_f32, normal_nw_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[0] + 16, buffer_f32, normal_nw_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[0] + 20, buffer_f32, normal_nw_b[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[1] + 12, buffer_f32, normal_nw_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[1] + 16, buffer_f32, normal_nw_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[1] + 20, buffer_f32, normal_nw_b[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[2] + 12, buffer_f32, normal_nw_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[2] + 16, buffer_f32, normal_nw_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_nw_b[2] + 20, buffer_f32, normal_nw_b[vec3.zz]);
        }
        #endregion
    }
    
    if (x < terrain.width - 1 && y > 0) {
        #region northeast
        var index_ne = [
            terrain_get_vertex_index(terrain, x, y - 1, 3),
            terrain_get_vertex_index(terrain, x, y - 1, 4),
            terrain_get_vertex_index(terrain, x, y - 1, 5),
        ];
        
        var values_ne = [
            buffer_peek(terrain.terrain_buffer_data, index_ne[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_ne[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_ne[2] + 8, buffer_f32),
        ];
        
        var normal_ne =     triangle_normal(x + 1, y,     values_ne[0],   x,     y,     values_ne[1],   x,     y - 1, values_ne[2]);
        
        if (smooth) {
            var normals = [normal_ne, normal_ne, normal_ne];
            
            var vertices = [
                [x + 1, y, values_ne[0], index_ne[0]], [x, y, values_ne[1], index_ne[1]], [x, y - 1, values_ne[2], index_ne[2]]
            ];
            
            for (var i = 0; i < 3; i++) {
                var normal = normals[i];
                var vertex = vertices[i];
                var key = string(vertex);
                if (source_vertices[$ key] == undefined) source_vertices[$ key] = vertex;
                if (normal_map[$ key] == undefined) {
                    normal_map[$ key] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
                } else {
                    var sN = normal_map[$ key];
                    normal_map[$ key] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
                }
            }
        } else {
            buffer_poke(terrain.terrain_buffer_data, index_ne[0] + 12, buffer_f32, normal_ne[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[0] + 16, buffer_f32, normal_ne[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[0] + 20, buffer_f32, normal_ne[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[1] + 12, buffer_f32, normal_ne[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[1] + 16, buffer_f32, normal_ne[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[1] + 20, buffer_f32, normal_ne[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[2] + 12, buffer_f32, normal_ne[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[2] + 16, buffer_f32, normal_ne[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_ne[2] + 20, buffer_f32, normal_ne[vec3.zz]);
        }
        #endregion
    }
    
    if (x > 0 && y < terrain.height - 1) {
        #region southwest
        var index_sw = [
            terrain_get_vertex_index(terrain, x - 1, y, 0),
            terrain_get_vertex_index(terrain, x - 1, y, 1),
            terrain_get_vertex_index(terrain, x - 1, y, 2),
        ];
        
        var values_sw = [
            buffer_peek(terrain.terrain_buffer_data, index_sw[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_sw[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_sw[2] + 8, buffer_f32),
        ];
        
        var normal_sw =     triangle_normal(x - 1, y,     values_sw[0],   x,     y,     values_sw[1],   x,     y + 1, values_sw[2]);
        
        if (smooth) {
            var normals = [normal_sw, normal_sw, normal_sw];
            
            var vertices = [
                [x - 1, y, values_sw[0], index_sw[0]], [x, y, values_sw[1], index_sw[1]], [x, y + 1, values_sw[2], index_sw[2]]
            ];
            
            for (var i = 0; i < 3; i++) {
                var normal = normals[i];
                var vertex = vertices[i];
                var key = string(vertex);
                if (source_vertices[$ key] == undefined) source_vertices[$ key] = vertex;
                if (normal_map[$ key] == undefined) {
                    normal_map[$ key] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
                } else {
                    var sN = normal_map[$ key];
                    normal_map[$ key] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
                }
            }
        } else {
            buffer_poke(terrain.terrain_buffer_data, index_sw[0] + 12, buffer_f32, normal_sw[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[0] + 16, buffer_f32, normal_sw[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[0] + 20, buffer_f32, normal_sw[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[1] + 12, buffer_f32, normal_sw[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[1] + 16, buffer_f32, normal_sw[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[1] + 20, buffer_f32, normal_sw[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[2] + 12, buffer_f32, normal_sw[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[2] + 16, buffer_f32, normal_sw[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_sw[2] + 20, buffer_f32, normal_sw[vec3.zz]);
        }
        #endregion
    }
    
    if (x < terrain.width - 1 && y < terrain.height - 1) {
        #region southeast
        var index_se_a = [
            terrain_get_vertex_index(terrain, x, y, 0),
            terrain_get_vertex_index(terrain, x, y, 1),
            terrain_get_vertex_index(terrain, x, y, 2),
        ];
        
        var index_se_b = [
            terrain_get_vertex_index(terrain, x, y, 3),
            terrain_get_vertex_index(terrain, x, y, 4),
            terrain_get_vertex_index(terrain, x, y, 5),
        ];
        
        var values_se_a = [
            buffer_peek(terrain.terrain_buffer_data, index_se_a[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_se_a[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_se_a[2] + 8, buffer_f32),
        ];
        
        var values_se_b = [
            buffer_peek(terrain.terrain_buffer_data, index_se_b[0] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_se_b[1] + 8, buffer_f32),
            buffer_peek(terrain.terrain_buffer_data, index_se_b[2] + 8, buffer_f32),
        ];
        
        var normal_se_a =   triangle_normal(x,     y,     values_se_a[0], x + 1, y,     values_se_a[1], x + 1, y + 1, values_se_a[2]);
        var normal_se_b =   triangle_normal(x + 1, y + 1, values_se_b[0], x,     y + 1, values_se_b[1], x,     y,     values_se_b[2]);
        
        if (smooth) {
            var normals = [normal_se_a, normal_se_a, normal_se_a, normal_se_b, normal_se_b, normal_se_b];
            
            var vertices = [
                [x, y, values_se_a[0], index_se_a[0]], [x + 1, y, values_se_a[1], index_se_a[1]], [x + 1, y + 1, values_se_a[2], index_se_a[2]],
                [x + 1, y + 1, values_se_b[0], index_se_b[0]], [x, y + 1, values_se_b[1], index_se_b[1]], [x, y, values_se_b[2], index_se_b[2]]
            ];
            
            for (var i = 0; i < 6; i++) {
                var normal = normals[i];
                var vertex = vertices[i];
                var key = string(vertex);
                if (source_vertices[$ key] == undefined) source_vertices[$ key] = vertex;
                if (normal_map[$ key] == undefined) {
                    normal_map[$ key] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
                } else {
                    var sN = normal_map[$ key];
                    normal_map[$ key] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
                }
            }
        } else {
            buffer_poke(terrain.terrain_buffer_data, index_se_a[0] + 12, buffer_f32, normal_se_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[0] + 16, buffer_f32, normal_se_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[0] + 20, buffer_f32, normal_se_a[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[1] + 12, buffer_f32, normal_se_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[1] + 16, buffer_f32, normal_se_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[1] + 20, buffer_f32, normal_se_a[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[2] + 12, buffer_f32, normal_se_a[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[2] + 16, buffer_f32, normal_se_a[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_a[2] + 20, buffer_f32, normal_se_a[vec3.zz]);
            
            buffer_poke(terrain.terrain_buffer_data, index_se_b[0] + 12, buffer_f32, normal_se_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[0] + 16, buffer_f32, normal_se_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[0] + 20, buffer_f32, normal_se_b[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[1] + 12, buffer_f32, normal_se_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[1] + 16, buffer_f32, normal_se_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[1] + 20, buffer_f32, normal_se_b[vec3.zz]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[2] + 12, buffer_f32, normal_se_b[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[2] + 16, buffer_f32, normal_se_b[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, index_se_b[2] + 20, buffer_f32, normal_se_b[vec3.zz]);
        }
        #endregion
    }
    
    if (smooth) {
        var vertices = variable_struct_get_names(normal_map);
        for (var i = 0; i < array_length(vertices); i++) {
            var vertex = source_vertices[$ vertices[i]];
            var normal = vector3_normalize(normal_map[$ string(vertex)]);
            // it's most likely not worth using lightweight objects here
            
            buffer_poke(terrain.terrain_buffer_data, vertex[3] + 12, buffer_f32, normal[vec3.xx]);
            buffer_poke(terrain.terrain_buffer_data, vertex[3] + 16, buffer_f32, normal[vec3.yy]);
            buffer_poke(terrain.terrain_buffer_data, vertex[3] + 20, buffer_f32, normal[vec3.zz]);
        }
    }
}