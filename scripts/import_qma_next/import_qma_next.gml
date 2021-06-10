function import_qma_next(data_buffer, version) {
    var json = json_parse(buffer_read(data_buffer, buffer_string));
    var mesh = new DataMesh(json.name);
    
    var bsize = json.size;
    
    var raw_buffer = buffer_read_buffer(data_buffer, bsize);
    
    var wbuffer = vertex_create_buffer();
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    var vsize, voff, vbuffer;
    var cdata = c_shape_create();
    c_shape_begin_trimesh();
    
    if (version >= 2) {
        vsize = VERTEX_SIZE;
        voff = 0;
        vbuffer = vertex_create_buffer_from_buffer(raw_buffer, Stuff.graphics.vertex_format);
    } else {
        vsize = 40;
        voff = 4;
        vbuffer = vertex_create_buffer();
        vertex_begin(vbuffer, Stuff.graphics.vertex_format);
    }
    
    for (var i = 0; i < bsize; i += 3 * vsize) {
        var x1 =  buffer_peek(raw_buffer, i + 000 + 0 * voff, buffer_f32);
        var y1 =  buffer_peek(raw_buffer, i + 004 + 0 * voff, buffer_f32);
        var z1 =  buffer_peek(raw_buffer, i + 008 + 0 * voff, buffer_f32);
        var nx1 = buffer_peek(raw_buffer, i + 012 + 0 * voff, buffer_f32);
        var ny1 = buffer_peek(raw_buffer, i + 016 + 0 * voff, buffer_f32);
        var nz1 = buffer_peek(raw_buffer, i + 020 + 0 * voff, buffer_f32);
        var xt1 = buffer_peek(raw_buffer, i + 024 + 0 * voff, buffer_f32);
        var yt1 = buffer_peek(raw_buffer, i + 028 + 0 * voff, buffer_f32);
        var c1 =  buffer_peek(raw_buffer, i + 032 + 0 * voff, buffer_f32);
        var x2 =  buffer_peek(raw_buffer, i + 036 + 1 * voff, buffer_f32);
        var y2 =  buffer_peek(raw_buffer, i + 040 + 1 * voff, buffer_f32);
        var z2 =  buffer_peek(raw_buffer, i + 044 + 1 * voff, buffer_f32);
        var nx2 = buffer_peek(raw_buffer, i + 048 + 1 * voff, buffer_f32);
        var ny2 = buffer_peek(raw_buffer, i + 052 + 1 * voff, buffer_f32);
        var nz2 = buffer_peek(raw_buffer, i + 056 + 1 * voff, buffer_f32);
        var xt2 = buffer_peek(raw_buffer, i + 060 + 1 * voff, buffer_f32);
        var yt2 = buffer_peek(raw_buffer, i + 064 + 1 * voff, buffer_f32);
        var c2 =  buffer_peek(raw_buffer, i + 068 + 1 * voff, buffer_f32);
        var x3 =  buffer_peek(raw_buffer, i + 072 + 2 * voff, buffer_f32);
        var y3 =  buffer_peek(raw_buffer, i + 076 + 2 * voff, buffer_f32);
        var z3 =  buffer_peek(raw_buffer, i + 080 + 2 * voff, buffer_f32);
        var nx3 = buffer_peek(raw_buffer, i + 084 + 2 * voff, buffer_f32);
        var ny3 = buffer_peek(raw_buffer, i + 088 + 2 * voff, buffer_f32);
        var nz3 = buffer_peek(raw_buffer, i + 092 + 2 * voff, buffer_f32);
        var xt3 = buffer_peek(raw_buffer, i + 096 + 2 * voff, buffer_f32);
        var yt3 = buffer_peek(raw_buffer, i + 100 + 2 * voff, buffer_f32);
        var c3 =  buffer_peek(raw_buffer, i + 104 + 2 * voff, buffer_f32);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        
        if (version < 2) {
            vertex_point_complete(vbuffer, x1, y1, z1, nx1, ny1, nz1, xt1, yt1, c1 & 0xffffff, (c1 >> 24) / 0xff);
            vertex_point_complete(vbuffer, x2, y2, z2, nx2, ny2, nz2, xt2, yt2, c2 & 0xffffff, (c2 >> 24) / 0xff);
            vertex_point_complete(vbuffer, x3, y3, z3, nx3, ny3, nz3, xt3, yt3, c3 & 0xffffff, (c3 >> 24) / 0xff);
        }
        
        c_shape_add_triangle(x1, y1, z1, x2, y2, z2, x3, y3, z3);
    }
    
    if (version < 2) {
        vertex_end(vbuffer);
        buffer_delete(raw_buffer);
        raw_buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
    }
    vertex_freeze(vbuffer);
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
    c_shape_end_trimesh(cdata);
    
    mesh_create_submesh(mesh, raw_buffer, vbuffer, wbuffer, undefined, mesh.name);
    internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(mesh.name));
    mesh.cshape = cdata;
    
    return mesh;
}