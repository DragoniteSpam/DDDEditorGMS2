/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityMesh

var buffer = argument0;
var wire = argument1;
var mesh = argument2;

var xx = mesh.xx * TILE_WIDTH;
var yy = mesh.yy * TILE_HEIGHT;
var zz = mesh.zz * TILE_DEPTH;

var data = guid_get(mesh.mesh); // lol
buffer_seek(data, buffer_seek_start, 0);

// Use the vertex_create_from_buffer instead of the buffer that I built, because
// the one that i built sucks
stack_trace();

var vc = 0;

var px = array_create(3);
var py = array_create(3);
var pz = array_create(3);
var nx, ny, nz, xtex, ytex, color, alpha;

while (buffer_tell(data) < buffer_get_size(data)) {
    // script arguments are parsed backwards and i don't think
    // there's a way to turn that off, and in any case it's a
    // better idea to just fetch the values first and *then*
    // pass them all to the script
    var npx = buffer_read(data, T);
    var npy = buffer_read(data, T);
    var npz = buffer_read(data, T);
    var transformed = transform_entity_point(mesh, npx, npy, npz);
    px[vc] = transformed[vec3.xx];
    py[vc] = transformed[vec3.yy];
    pz[vc] = transformed[vec3.zz];
    nx = buffer_read(data, T);
    ny = buffer_read(data, T);
    nz = buffer_read(data, T);
    xtex = buffer_read(data, T);
    ytex = buffer_read(data, T);
    color = buffer_read(data, T);
    alpha = buffer_read(data, T);
    
    vertex_point_complete(buffer, px[vc], py[vc], pz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    
    vc = ++vc % 3;
    
    if (vc == 0) {
        vertex_point_line(wire, px[0], py[0], pz[0], c_white, 1);
        vertex_point_line(wire, px[1], py[1], pz[1], c_white, 1);
        
        vertex_point_line(wire, px[1], py[1], pz[1], c_white, 1);
        vertex_point_line(wire, px[2], py[2], pz[2], c_white, 1);
        
        vertex_point_line(wire, px[2], py[2], pz[2], c_white, 1);
        vertex_point_line(wire, px[0], py[0], pz[0], c_white, 1);
    }
}

return [buffer, wire];