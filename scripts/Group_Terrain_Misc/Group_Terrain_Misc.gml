vertex_format_begin();
vertex_format_add_position();
vertex_format_add_colour();
global.vertex_format_terrain = vertex_format_end();

#macro TERRAIN_INTERNAL_CHUNK_SIZE 256
#macro TERRAIN_INTERNAL_LOD_REDUCTION (8 * 8)

function terrain_create_patch(size, res) {
    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vertex_format_terrain);
    for (var i = 0; i < size; i += res) {
        for (var j = 0; j < size; j += res) {
            vertex_position(vb, i, j);
            vertex_colour(vb, c_red, 1);
            vertex_position(vb, i + res, j);
            vertex_colour(vb, c_lime, 1);
            vertex_position(vb, i + res, j + res);
            vertex_colour(vb, c_blue, 1);
            vertex_position(vb, i + res, j + res);
            vertex_colour(vb, c_blue, 1);
            vertex_position(vb, i, j + res);
            vertex_colour(vb, c_lime, 1);
            vertex_position(vb, i, j);
            vertex_colour(vb, c_red, 1);
        }
    }
    vertex_end(vb);
    vertex_freeze(vb);
    return vb;
};