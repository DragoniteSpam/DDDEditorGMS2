/// @param filename

var fn = argument0;

var f = file_text_open_read(fn);
file_text_readln(f);
var n = file_text_read_real(f) - 2;
file_text_readln(f);

var vbuffer = vertex_create_buffer();
var wbuffer = vertex_create_buffer();
var cshape = c_shape_create();

c_shape_begin_trimesh();
vertex_begin(vbuffer, Camera.vertex_format);
vertex_begin(wbuffer, Camera.vertex_format);

var vc = 0;

var xx = [0, 0, 0];
var yy = [0, 0, 0];
var zz = [0, 0, 0];
var nx, ny, nz, xtex, ytex, color, alpha, type, skip;

var minx = 0;
var miny = 0;
var minz = 0;
var maxx = 0;
var maxy = 0;
var maxz = 0;

while (!file_text_eof(f)){
    type = file_text_read_real(f);
    
    nx = 0;
    ny = 0;
    nz = 0;
    xtex = 0;
    ytex = 0
    color = c_white;
    alpha = 1;
    
    skip = false;
    
    switch (type){
        case 0:
        case 1:
            file_text_readln(f);
            skip = true;
            break;
        case 2:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 3:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            color = file_text_read_real(f);
            alpha = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 4:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            xtex = file_text_read_real(f);
            ytex = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 5:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            xtex = file_text_read_real(f);
            ytex = file_text_read_real(f);
            color = file_text_read_real(f);
            alpha = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 6:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            nx = file_text_read_real(f);
            ny = file_text_read_real(f);
            nz = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 7:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            nx = file_text_read_real(f);
            ny = file_text_read_real(f);
            nz = file_text_read_real(f);
            color = file_text_read_real(f);
            alpha = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 8:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            nx = file_text_read_real(f);
            ny = file_text_read_real(f);
            nz = file_text_read_real(f);
            xtex = file_text_read_real(f);
            ytex = file_text_read_real(f);
            file_text_readln(f);
            break;
        case 9:
            xx[vc] = file_text_read_real(f);
            yy[vc] = file_text_read_real(f);
            zz[vc] = file_text_read_real(f);
            nx = file_text_read_real(f);
            ny = file_text_read_real(f);
            nz = file_text_read_real(f);
            xtex = file_text_read_real(f);
            ytex = file_text_read_real(f);
            color = file_text_read_real(f);
            alpha = file_text_read_real(f);
            file_text_readln(f);
            break;
        default:
            debug("Unsupported structure in " + fn + ", skipping. Please convert your primitive shapes into triangles. Thank.");
            file_text_readln(f);
            skip = true;
            break;
    }
    
    if (skip) {
        continue;
    }
    
    // because the texture doesn't take up the entire space on the texture page
    // i MAY come up with a way of doing individual textures for meshes, but not now
    xtex = xtex * TILESET_TEXTURE_WIDTH;
    ytex = ytex * TILESET_TEXTURE_HEIGHT;
    
    minx = min(minx, xx[vc]);
    miny = min(miny, yy[vc]);
    minz = min(minz, zz[vc]);
    maxx = max(maxx, xx[vc]);
    maxy = max(maxy, yy[vc]);
    maxz = max(maxz, zz[vc]);
    
    vertex_point_complete(vbuffer, xx[vc], yy[vc], zz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    
    vc = (++vc) % 3;
    
    if (vc == 0) {
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        
        c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
    }
}

vertex_end(vbuffer);
vertex_end(wbuffer);
c_shape_end_trimesh(cshape);

var mesh = instance_create_depth(0, 0, 0, DataMesh);

mesh.xmin = round(minx / IMPORT_GRID_SIZE);
mesh.ymin = round(miny / IMPORT_GRID_SIZE);
mesh.zmin = round(minz / IMPORT_GRID_SIZE);
mesh.xmax = round(maxx / IMPORT_GRID_SIZE);
mesh.ymax = round(maxy / IMPORT_GRID_SIZE);
mesh.zmax = round(maxz / IMPORT_GRID_SIZE);

var base_name = filename_change_ext(filename_name(fn), "");
mesh.name = base_name;
var internal_name = string_lettersdigits(base_name);
while (internal_name_get(internal_name)) {
    internal_name = string_lettersdigits(base_name) + string(irandom(65535));
}
internal_name_set(mesh, internal_name);
mesh.buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
mesh.vbuffer = vbuffer;
mesh.wbuffer = wbuffer;
mesh.cshape = cshape;

vertex_freeze(vbuffer);
vertex_freeze(wbuffer);

return mesh;