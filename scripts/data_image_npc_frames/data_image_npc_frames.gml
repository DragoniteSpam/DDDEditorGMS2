function data_image_npc_frames(image) {
    var ww = 1 / image.hframes * (image.width / sprite_get_width(image.picture));
    var hh = 1 / image.vframes * (image.height / sprite_get_height(image.picture));
    
    for (var i = 0; i < array_length(image.npc_frames); i++) {
        vertex_delete_buffer(image.npc_frames[i]);
    }
    
    image.npc_frames = array_create(image.hframes * image.vframes);
    
    for (var i = 0; i < image.hframes * image.vframes; i++) {
        var vbuffer = vertex_create_buffer();
        vertex_begin(vbuffer, Stuff.graphics.vertex_format);
        
        var uu = (i % image.hframes) * ww;
        var vv = (i div image.hframes) * hh;
        
        vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    uu, vv,             c_white, 1);
        vertex_point_complete(vbuffer, TILE_WIDTH, 0, TILE_DEPTH,   0, sqrt(2), sqrt(2),    uu + ww, vv,        c_white, 1);
        vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    uu + ww, vv + hh,   c_white, 1);
        
        vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    uu + ww, vv + hh,   c_white, 1);
        vertex_point_complete(vbuffer, 0, TILE_HEIGHT, 0,           0, sqrt(2), sqrt(2),    uu, vv + hh,        c_white, 1);
        vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    uu, vv,             c_white, 1);
        
        vertex_end(vbuffer);
        vertex_freeze(vbuffer);
        image.npc_frames[i] = vbuffer;
    }
}