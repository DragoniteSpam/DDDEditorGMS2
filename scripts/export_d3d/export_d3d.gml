/// @param fname
/// @param mesh

var fn = argument0;
var mesh = argument1;

var buffer = buffer_create(1024, buffer_grow, 1);
buffer_write(buffer, buffer_text, "100\r\n");
buffer_write(buffer, buffer_text, string(buffer_get_size(mesh.buffer) / VERTEX_FORMAT_SIZE) + "\r\n");
buffer_write(buffer, buffer_text, "0 4\r\n");

buffer_seek(mesh.buffer, buffer_seek_start, 0);

while (buffer_tell(mesh.buffer) < buffer_get_size(mesh.buffer)) {
    var xx = buffer_read(mesh.buffer, buffer_f32);
    var yy = buffer_read(mesh.buffer, buffer_f32);
    var zz = buffer_read(mesh.buffer, buffer_f32);
    var nx = buffer_read(mesh.buffer, buffer_f32);
    var ny = buffer_read(mesh.buffer, buffer_f32);
    var nz = buffer_read(mesh.buffer, buffer_f32);
    var xtex = buffer_read(mesh.buffer, buffer_f32);
    var ytex = buffer_read(mesh.buffer, buffer_f32);
    var color = buffer_read(mesh.buffer, buffer_u32);
    buffer_read(mesh.buffer, buffer_u32);
    
    buffer_write(buffer, buffer_text, "9 " + decimal(xx) + " " + decimal(yy) + " " + decimal(zz) +
        " " + decimal(nx) + " " + decimal(ny) + " " + decimal(nz) + " " + decimal(xtex) + " " +
        decimal(ytex) + " " + decimal(color & 0xffffff) + " " + decimal(((color >> 24) & 0xff) / 255) + "\r\n");
}

buffer_write(buffer, buffer_text, "1\r\n");
buffer_save(buffer, fn);
buffer_delete(buffer);