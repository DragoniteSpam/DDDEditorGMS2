/// @param DataImage

var data = argument0;

var ww = 1 / data.hframes;
var hh = 1 / data.vframes;

for (var i = 0; i < array_length_1d(data.npc_frames); i++) {
    vertex_delete_buffer(data.npc_frames[i]);
}

data.npc_frames = array_create(data.hframes, data.vframes);

for (var i = 0; i < data.hframes * data.vframes; i++) {
    var vbuffer = vertex_create_buffer();
    vertex_begin(vbuffer, Stuff.graphics.vertex_format);
        
    var xx = (i % data.hframes) * ww;
    var yy = (i div data.hframes) * hh;
        
    vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    xx, yy,             c_white, 1);
    vertex_point_complete(vbuffer, TILE_WIDTH, 0, TILE_DEPTH,   0, sqrt(2), sqrt(2),    xx + ww, yy,        c_white, 1);
    vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    xx + ww, yy + hh,   c_white, 1);
        
    vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    xx + ww, yy + hh,   c_white, 1);
    vertex_point_complete(vbuffer, 0, TILE_HEIGHT, 0,           0, sqrt(2), sqrt(2),    xx, yy + hh,        c_white, 1);
    vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    xx, yy,             c_white, 1);
        
    vertex_end(vbuffer);
    vertex_freeze(vbuffer);
    data.npc_frames[i] = vbuffer;
}