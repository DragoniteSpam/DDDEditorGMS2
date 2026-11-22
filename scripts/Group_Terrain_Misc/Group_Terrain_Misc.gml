vertex_format_begin();
vertex_format_add_position();
global.vertex_format_terrain = vertex_format_end();

var terrain_create_patch = function(size, res) {
    var vb = vertex_create_buffer();
    vertex_begin(vb, global.vertex_format_terrain);
    for (var i = 0; i < size; i += res) {
        for (var j = 0; j < size; j += res) {
            vertex_position(vb, i, j);
            vertex_position(vb, i + res, j);
            vertex_position(vb, i + res, j + res);
            vertex_position(vb, i + res, j + res);
            vertex_position(vb, i, j + res);
            vertex_position(vb, i, j);
        }
    }
    vertex_end(vb);
    vertex_freeze(vb);
    return vb;
};