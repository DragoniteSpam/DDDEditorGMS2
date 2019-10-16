/// @param vertex-buffer
/// @param wireframe-buffer
/// @param EntityMesh

var buffer = argument0;
var wire = argument1;
var mesh = argument2;

switch (mesh.type) {
    case MeshTypes.RAW: break;
    case MeshTypes.SMF: return [buffer, wire];
}

var xx = mesh.xx * TILE_WIDTH;
var yy = mesh.yy * TILE_HEIGHT;
var zz = mesh.zz * TILE_DEPTH;

var data = guid_get(mesh.mesh); // lol
buffer_seek(data.buffer, buffer_seek_start, 0);

var vc = 0;

var px = array_create(3);
var py = array_create(3);
var pz = array_create(3);
var nx, ny, nz, xtex, ytex, color, alpha, extra;

while (buffer_tell(data.buffer) < buffer_get_size(data.buffer)) {
    // script arguments are parsed backwards and i don't think there's a way to
    // turn that off, and in any case it's a better idea to just fetch the
    // values first and *then* pass them all to the script. it's quite annoying.
    var npx = buffer_read(data.buffer, buffer_f32);
    var npy = buffer_read(data.buffer, buffer_f32);
    var npz = buffer_read(data.buffer, buffer_f32);
    var transformed = transform_entity_point(mesh, npx, npy, npz);
    px[vc] = transformed[vec3.xx];
    py[vc] = transformed[vec3.yy];
    pz[vc] = transformed[vec3.zz];
    nx = buffer_read(data.buffer, buffer_f32);
    ny = buffer_read(data.buffer, buffer_f32);
    nz = buffer_read(data.buffer, buffer_f32);
    xtex = buffer_read(data.buffer, buffer_f32);
    ytex = buffer_read(data.buffer, buffer_f32);
    color = buffer_read(data.buffer, buffer_u32);
    extra = buffer_read(data.buffer, buffer_u32);
    
    alpha = color >> 24;
    color = color | 0xffffff;
    
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