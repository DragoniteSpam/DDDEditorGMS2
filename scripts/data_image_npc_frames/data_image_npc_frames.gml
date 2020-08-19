/// @param DataImage
function data_image_npc_frames(argument0) {

	var data = argument0;

	var ww = 1 / data.hframes * (data.width / sprite_get_width(data.picture));
	var hh = 1 / data.vframes * (data.height / sprite_get_height(data.picture));

	for (var i = 0; i < array_length(data.npc_frames); i++) {
	    vertex_delete_buffer(data.npc_frames[i]);
	}

	data.npc_frames = array_create(data.hframes, data.vframes);

	for (var i = 0; i < data.hframes * data.vframes; i++) {
	    var vbuffer = vertex_create_buffer();
	    vertex_begin(vbuffer, Stuff.graphics.vertex_format);
    
	    var uu = (i % data.hframes) * ww;
	    var vv = (i div data.hframes) * hh;
    
	    vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    uu, vv,             c_white, 1);
	    vertex_point_complete(vbuffer, TILE_WIDTH, 0, TILE_DEPTH,   0, sqrt(2), sqrt(2),    uu + ww, vv,        c_white, 1);
	    vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    uu + ww, vv + hh,   c_white, 1);
    
	    vertex_point_complete(vbuffer, TILE_WIDTH, TILE_HEIGHT, 0,  0, sqrt(2), sqrt(2),    uu + ww, vv + hh,   c_white, 1);
	    vertex_point_complete(vbuffer, 0, TILE_HEIGHT, 0,           0, sqrt(2), sqrt(2),    uu, vv + hh,        c_white, 1);
	    vertex_point_complete(vbuffer, 0, 0, TILE_DEPTH,            0, sqrt(2), sqrt(2),    uu, vv,             c_white, 1);
    
	    vertex_end(vbuffer);
	    vertex_freeze(vbuffer);
	    data.npc_frames[i] = vbuffer;
	}


}
