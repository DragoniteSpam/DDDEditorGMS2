/// @param filename
/// @param [complete-object?]
/// @param [adjust-UVs?]
/// @param [include-raw-buffer?]
/// @param [existing-object]
/// @param [replace-index]

// returns either a vertex buffer or an array of [vertex buffer, data buffer] depending
// on what you ask it for
// this is VERY bad but i don't want to write more than one d3d importers, or to offload
// the d3d code to somewhere else, so it stays like this for now

var fn = argument[0];
// setting "everything" to false will mean only the vertex buffer is returned
var everything = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
var adjust = (argument_count > 2 && argument[2] != undefined) ? argument[2] : true;
var raw_buffer = (argument_count > 3 && argument[3] != undefined) ? argument[3] : false;
var existing = (argument_count > 4 && argument[4] != undefined) ? argument[4] : noone;
var replace_index = (argument_count > 5 && argument[5] != undefined) ? argument[5] : -1;
var data_added = false;

var f = file_text_open_read(fn);
file_text_readln(f);
var n = file_text_read_real(f) - 2;
file_text_readln(f);

var vbuffer = vertex_create_buffer();
if (everything) {
    var wbuffer = vertex_create_buffer();
    var cshape = c_shape_create();
}

vertex_begin(vbuffer, Stuff.graphics.vertex_format);
if (everything) {
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    c_shape_begin_trimesh();
}

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

#region big fat loop
while (!file_text_eof(f)) {
    type = file_text_read_real(f);
    
    nx = 0;
    ny = 0;
    nz = 0;
    xtex = 0;
    ytex = 0
    color = c_white;
    alpha = 1;
    
    skip = false;
    
    switch (type) {
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
            wtf("Unsupported structure in " + fn + ", skipping. Please convert your primitive shapes into triangles. Thank.");
            file_text_readln(f);
            skip = true;
            break;
    }
    
    if (skip) {
        continue;
    }
    
    if (adjust) {
        xtex = xtex * TILESET_TEXTURE_SCALE;
        ytex = ytex * TILESET_TEXTURE_SCALE;
    }
    
    // the texture pages are 4k, so this is four pixels squared
    xtex = round_ext(xtex, 1 / 1024);
    ytex = round_ext(ytex, 1 / 1024);
    
    minx = min(minx, xx[vc]);
    miny = min(miny, yy[vc]);
    minz = min(minz, zz[vc]);
    maxx = max(maxx, xx[vc]);
    maxy = max(maxy, yy[vc]);
    maxz = max(maxz, zz[vc]);
    
    vertex_point_complete(vbuffer, xx[vc], yy[vc], zz[vc], nx, ny, nz, xtex, ytex, color, alpha);
    
    data_added = true;
    vc = (++vc) % 3;
    
    if (everything && vc == 0) {
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        
        vertex_point_line(wbuffer, xx[1], yy[1], zz[1], c_white, 1);
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        
        vertex_point_line(wbuffer, xx[2], yy[2], zz[2], c_white, 1);
        vertex_point_line(wbuffer, xx[0], yy[0], zz[0], c_white, 1);
        
        c_shape_add_triangle(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
    }
}
#endregion

file_text_close(f);
vertex_end(vbuffer);

var dbuffer = raw_buffer ? buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1) : noone;

if (!data_added) {
    vertex_delete_buffer(vbuffer);
    vbuffer = noone;
}

if (everything) {
    if (data_added) {
        vertex_end(wbuffer);
        c_shape_end_trimesh(cshape);
    } else {
        vertex_delete_buffer(wbuffer);
        c_shape_destroy(cshape);
    }
    
    var base_name = filename_change_ext(filename_name(fn), "");
    var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
    
    if (!existing) {
        mesh.xmin = round(minx / IMPORT_GRID_SIZE);
        mesh.ymin = round(miny / IMPORT_GRID_SIZE);
        mesh.zmin = round(minz / IMPORT_GRID_SIZE);
        mesh.xmax = round(maxx / IMPORT_GRID_SIZE);
        mesh.ymax = round(maxy / IMPORT_GRID_SIZE);
        mesh.zmax = round(maxz / IMPORT_GRID_SIZE);
        
        mesh.name = base_name;
        data_mesh_recalculate_bounds(mesh);
        internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
    }
    
    if (data_added) {
        mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1), vbuffer, wbuffer, undefined, base_name, replace_index, fn);
        if (!mesh.cshape) {
            mesh.cshape = cshape;
        } else {
            c_shape_destroy(cshape);
        }
        
        vertex_freeze(vbuffer);
        vertex_freeze(wbuffer);
    }
    
    return mesh;
}

return raw_buffer ? [vbuffer, dbuffer] : vbuffer;