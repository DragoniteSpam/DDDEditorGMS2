event_inherited();

if (buffer) vertex_delete_buffer(buffer);
if (vbuffer) vertex_delete_buffer(vbuffer);
if (wbuffer) vertex_delete_buffer(wbuffer);
if (cshape) c_shape_destroy(cshape);