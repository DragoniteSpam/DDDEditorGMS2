function d3d_model_load(filename, freeze = false) {
    var data = buffer_load(filename);
    var content = buffer_read(data, buffer_string);
    buffer_delete(data);
    var lines = string_split(content, "\n");
    array_filter_ext(lines, function(text, index) {
        return text != "" && index >= 2;
    });
    array_map_ext(lines, function(text) {
        return string_trim(text);
    });
    
    static vertex = Drago3D_Internals.Vertex;
    static format = Drago3D_Internals.format;
    
    var vbuff = vertex_create_buffer();
    vertex_begin(vbuff, format);
    
    for (var i = 0, n = array_length(lines); i < n; i++) {
        var tokens = string_split(lines[i], " ");
        switch (tokens[0]) {
            case 0: case 1: break;
            case 2: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                vertex(vbuff, xx, yy, zz, 0, 0, 0, 0, 0, c_white, 1);
            } break;
            case 3: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var cc = real(tokens[4]);
                var aa = real(tokens[5]);
                vertex(vbuff, xx, yy, zz, 0, 0, 0, 0, 0, cc, aa);
            } break;
            case 4: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var uu = real(tokens[4]);
                var vv = real(tokens[5]);
                vertex(vbuff, xx, yy, zz, 0, 0, 0, uu, vv, c_white, 1);
            } break;
            case 5: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var uu = real(tokens[4]);
                var vv = real(tokens[5]);
                var cc = real(tokens[6]);
                var aa = real(tokens[7]);
                vertex(vbuff, xx, yy, zz, 0, 0, 0, uu, vv, cc, aa);
            } break;
            case 6: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var nx = real(tokens[4]);
                var ny = real(tokens[5]);
                var nz = real(tokens[6]);
                vertex(vbuff, xx, yy, zz, nx, ny, nz, 0, 0, c_white, 1);
            } break;
            case 7: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var nx = real(tokens[4]);
                var ny = real(tokens[5]);
                var nz = real(tokens[6]);
                var cc = real(tokens[7]);
                var aa = real(tokens[8]);
                vertex(vbuff, xx, yy, zz, nx, ny, nz, 0, 0, cc, aa);
            } break;
            case 8: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var nx = real(tokens[4]);
                var ny = real(tokens[5]);
                var nz = real(tokens[6]);
                var uu = real(tokens[7]);
                var vv = real(tokens[8]);
                vertex(vbuff, xx, yy, zz, nx, ny, nz, uu, vv, c_white, 1);
            } break;
            case 9: {
                var xx = real(tokens[1]);
                var yy = real(tokens[2]);
                var zz = real(tokens[3]);
                var nx = real(tokens[4]);
                var ny = real(tokens[5]);
                var nz = real(tokens[6]);
                var uu = real(tokens[7]);
                var vv = real(tokens[8]);
                var cc = real(tokens[9]);
                var aa = real(tokens[10]);
                vertex(vbuff, xx, yy, zz, nx, ny, nz, uu, vv, cc, aa);
            } break;
            case 10:
                break;
            case 11:
                break;
            case 12:
                break;
            case 13:
                break;
            case 14:
                break;
            case 15:
                break;
            case 16:
                break;
        }
    }
    
    vertex_end(vbuff);
    
    if (freeze) {
        vertex_freeze(vbuff);
    }
    
    return vbuff;
}