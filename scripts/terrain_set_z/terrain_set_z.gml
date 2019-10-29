/// @param terrain
/// @param x
/// @param y
/// @param value

var terrain = argument0;
var xx = argument1;
var yy = argument2;
var value = argument3;
var smooth = true;
var threshold = 0.3;

// @todo gml update when lwos come around i think an "add" method would be pretty handy here

buffer_poke(terrain.height_data, terrain_get_data_index(terrain, xx, yy), buffer_f32, value);

var normal_map = ds_map_create();

if (xx > 0 && yy > 0) {
    #region northwest
    var index_nw_a = [
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 0),
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 1),
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 2),
    ];
    
    var index_nw_b = [
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 3),
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 4),
        terrain_get_vertex_index(terrain, xx - 1, yy - 1, 5),
    ];
    
    buffer_poke(terrain.terrain_buffer_data, index_nw_a[2] + 8, buffer_f32, value);
    buffer_poke(terrain.terrain_buffer_data, index_nw_b[0] + 8, buffer_f32, value);
    
    var values_nw_a = [
        buffer_peek(terrain.terrain_buffer_data, index_nw_a[0] + 8, buffer_f32),
        buffer_peek(terrain.terrain_buffer_data, index_nw_a[1] + 8, buffer_f32),
        value,
    ];
    
    var values_nw_b = [
        value,
        buffer_peek(terrain.terrain_buffer_data, index_nw_b[1] + 8, buffer_f32),
        buffer_peek(terrain.terrain_buffer_data, index_nw_b[2] + 8, buffer_f32),
    ];
    
    var normal_nw_a =   triangle_normal(xx - 1, yy - 1, values_nw_a[0], xx,     yy - 1, values_nw_a[1], xx,     yy,     values_nw_a[2]);
    var normal_nw_b =   triangle_normal(xx,     yy,     values_nw_b[0], xx - 1, yy,     values_nw_b[1], xx - 1, yy - 1, values_nw_b[2]);
    
    if (smooth) {
        var normals = [normal_nw_a, normal_nw_a, normal_nw_a, normal_nw_b, normal_nw_b, normal_nw_b];
        
        var vertices = [
            [xx - 1, yy - 1, values_nw_a[0], index_nw_a[0]], [xx, yy - 1, values_nw_a[1], index_nw_a[1]], [xx, yy, values_nw_a[2], index_nw_a[2]],
            [xx, yy, values_nw_b[0], index_nw_b[0]], [xx - 1, yy, values_nw_b[1], index_nw_b[1]], [xx - 1, yy - 1, values_nw_b[2], index_nw_b[2]]
        ];
        
        for (var i = 0; i < 6; i++) {
            var normal = normals[i];
            var vertex = vertices[i];
            if (!ds_map_exists(normal_map, vertex)) {
                normal_map[? vertex] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
            } else {
                var sN = normal_map[? vertex];
                normal_map[? vertex] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
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

if (xx < terrain.width - 1 && yy > 0) {
    #region northeast
    var index_ne = [
        terrain_get_vertex_index(terrain, xx, yy - 1, 3),
        terrain_get_vertex_index(terrain, xx, yy - 1, 4),
        terrain_get_vertex_index(terrain, xx, yy - 1, 5),
    ];
    
    buffer_poke(terrain.terrain_buffer_data, index_ne[1] + 8, buffer_f32, value);
    
    var values_ne = [
        buffer_peek(terrain.terrain_buffer_data, index_ne[0] + 8, buffer_f32),
        value,
        buffer_peek(terrain.terrain_buffer_data, index_ne[2] + 8, buffer_f32),
    ];
    
    var normal_ne =     triangle_normal(xx + 1, yy,     values_ne[0],   xx,     yy,     values_ne[1],   xx,     yy - 1, values_ne[2]);
    
    if (smooth) {
        var normals = [normal_ne, normal_ne, normal_ne];
        
        var vertices = [
            [xx + 1, yy, values_ne[0], index_ne[0]], [xx, yy, values_ne[1], index_ne[1]], [xx, yy - 1, values_ne[2], index_ne[2]]
        ];
        
        for (var i = 0; i < 3; i++) {
            var normal = normals[i];
            var vertex = vertices[i];
            if (!ds_map_exists(normal_map, vertex)) {
                normal_map[? vertex] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
            } else {
                var sN = normal_map[? vertex];
                normal_map[? vertex] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
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

if (xx > 0 && yy < terrain.height - 1) {
    #region southwest
    var index_sw = [
        terrain_get_vertex_index(terrain, xx - 1, yy, 0),
        terrain_get_vertex_index(terrain, xx - 1, yy, 1),
        terrain_get_vertex_index(terrain, xx - 1, yy, 2),
    ];
    
    buffer_poke(terrain.terrain_buffer_data, index_sw[1] + 8, buffer_f32, value);
    
    var values_sw = [
        buffer_peek(terrain.terrain_buffer_data, index_sw[0] + 8, buffer_f32),
        value,
        buffer_peek(terrain.terrain_buffer_data, index_sw[2] + 8, buffer_f32),
    ];
    
    var normal_sw =     triangle_normal(xx - 1, yy,     values_sw[0],   xx,     yy,     values_sw[1],   xx,     yy + 1, values_sw[2]);
    
    if (smooth) {
        var normals = [normal_sw, normal_sw, normal_sw];
        
        var vertices = [
            [xx - 1, yy, values_sw[0], index_sw[0]], [xx, yy, values_sw[1], index_sw[1]], [xx, yy + 1, values_sw[2], index_sw[2]]
        ];
        
        for (var i = 0; i < 3; i++) {
            var normal = normals[i];
            var vertex = vertices[i];
            if (!ds_map_exists(normal_map, vertex)) {
                normal_map[? vertex] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
            } else {
                var sN = normal_map[? vertex];
                normal_map[? vertex] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
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

if (xx < terrain.width - 1 && yy < terrain.height - 1) {
    #region southeast
    var index_se_a = [
        terrain_get_vertex_index(terrain, xx, yy, 0),
        terrain_get_vertex_index(terrain, xx, yy, 1),
        terrain_get_vertex_index(terrain, xx, yy, 2),
    ];
    
    var index_se_b = [
        terrain_get_vertex_index(terrain, xx, yy, 3),
        terrain_get_vertex_index(terrain, xx, yy, 4),
        terrain_get_vertex_index(terrain, xx, yy, 5),
    ];
    
    buffer_poke(terrain.terrain_buffer_data, index_se_a[0] + 8, buffer_f32, value);
    buffer_poke(terrain.terrain_buffer_data, index_se_b[2] + 8, buffer_f32, value);
    
    var values_se_a = [
        value,
        buffer_peek(terrain.terrain_buffer_data, index_se_a[1] + 8, buffer_f32),
        buffer_peek(terrain.terrain_buffer_data, index_se_a[2] + 8, buffer_f32),
    ];
    
    var values_se_b = [
        buffer_peek(terrain.terrain_buffer_data, index_se_b[0] + 8, buffer_f32),
        buffer_peek(terrain.terrain_buffer_data, index_se_b[1] + 8, buffer_f32),
        value,
    ];
    
    var normal_se_a =   triangle_normal(xx,     yy,     values_se_a[0], xx + 1, yy,     values_se_a[1], xx + 1, yy + 1, values_se_a[2]);
    var normal_se_b =   triangle_normal(xx + 1, yy + 1, values_se_b[0], xx,     yy + 1, values_se_b[1], xx,     yy,     values_se_b[2]);
    
    if (smooth) {
        var normals = [normal_se_a, normal_se_a, normal_se_a, normal_se_b, normal_se_b, normal_se_b];
        
        var vertices = [
            [xx, yy, values_se_a[0], index_se_a[0]], [xx + 1, yy, values_se_a[1], index_se_a[1]], [xx + 1, yy + 1, values_se_a[2], index_se_a[2]],
            [xx + 1, yy + 1, values_se_b[0], index_se_b[0]], [xx, yy + 1, values_se_b[1], index_se_b[1]], [xx, yy, values_se_b[2], index_se_b[2]]
        ];
        
        for (var i = 0; i < 6; i++) {
            var normal = normals[i];
            var vertex = vertices[i];
            if (!ds_map_exists(normal_map, vertex)) {
                normal_map[? vertex] = [normal[vec3.xx], normal[vec3.yy], normal[vec3.zz]];
            } else {
                var sN = normal_map[? vertex];
                normal_map[? vertex] = [sN[vec3.xx] + normal[vec3.xx], sN[vec3.yy] + normal[vec3.yy], sN[vec3.zz] + normal[vec3.zz]];
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
    for (var vertex = ds_map_find_first(normal_map); vertex != ds_map_find_last(normal_map); vertex = ds_map_find_next(normal_map, vertex)) {
        var normal = normalize_vec3(normal_map[? vertex]);
        // it's most likely not worth using lightweight objects here
        
        buffer_poke(terrain.terrain_buffer_data, vertex[3] + 12, buffer_f32, normal[vec3.xx]);
        buffer_poke(terrain.terrain_buffer_data, vertex[3] + 16, buffer_f32, normal[vec3.yy]);
        buffer_poke(terrain.terrain_buffer_data, vertex[3] + 20, buffer_f32, normal[vec3.zz]);
    }
}

ds_map_destroy(normal_map);