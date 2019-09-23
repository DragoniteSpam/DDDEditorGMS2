/// @param fname
// this is for mesh autotiles specifically - more general ones can be
// found in import_d3d
// I ripped the guts out of a compatibility script becuase I didn't feel like writing it on my own
// it doesn't freeze the vertex buffer - that's on you

if (!file_exists(argument0)) {
	return -1;
}

var f = file_text_open_read(argument0);

var v = file_text_read_real(f);
if (v != 100) {
	file_text_close(f);
	return - 1;
}

file_text_readln(f);

var nthings = file_text_read_real(f);
file_text_readln(f);
var buffer = vertex_create_buffer();
var thing = 0;

while(thing < nthings) {
	// Every entry is 11 values - 1 'command' and 10 parameters
	var type = round(file_text_read_real(f));
	var args;
	var i = 0;
	repeat (10) {
		args[i++] = file_text_read_real(f);
	}
	file_text_readln(f);
	
	switch (type) {
		case 0:
			vertex_begin(buffer, Camera.vertex_format);
			break;
		case 1:
			vertex_end(buffer);
			break;
		case 9:
			vertex_position_3d(buffer, args[0], args[1], args[2]);
			vertex_normal(buffer, args[3], args[4], args[5]);
			vertex_texcoord(buffer, args[6] * TILESET_TEXTURE_WIDTH, args[7] * TILESET_TEXTURE_HEIGHT);
			vertex_color(buffer, args[8], args[9]);
            // extra vec4 that doesn't do anything here
            vertex_color(buffer, c_white, 1);
			break;
	}
	
	thing++;
}

file_text_close(f);

return buffer;