/// @description spart__load_obj_to_buffer(fname)
/// @param fname
/*
	Loads an OBJ model file into a buffer
*/
var filename = argument0;
var file = file_text_open_read(filename);
if file == -1{show_debug_message("Failed to load model " + string(filename)); return -1;}
show_debug_message("Script spart___load_obj_to_buffer: Loading obj file " + string(filename));

//Create the necessary lists
var V, N, T, F;
V = ds_list_create();
N = ds_list_create();
T = ds_list_create();
F = ds_list_create();

//Read .obj as textfile
var str, type;
while !file_text_eof(file)
{
	str = string_replace_all(file_text_read_string(file),"  "," ");
	//Different types of information in the .obj starts with different headers
	switch string_copy(str, 1, string_pos(" ", str)-1)
	{
		//Load vertex positions
		case "v":
			ds_list_add(V, spart__read_obj_line(str));
			break;
		//Load vertex normals
		case "vn":
			ds_list_add(N, spart__read_obj_line(str));
			break;
		//Load vertex texture coordinates
		case "vt":
			ds_list_add(T, spart__read_obj_line(str));
			break;
		//Load faces
		case "f":
			spart__read_obj_face(F, str);
			break;
	}
	file_text_readln(file);
}
file_text_close(file);

//Loop through the loaded information and generate a model
var vnt, vertNum, mbuff, vbuff, v, n, t;
var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
vertNum = ds_list_size(F);
mbuff = buffer_create(vertNum * bytesPerVert, buffer_fixed, 1);
for (var f = 0; f < vertNum; f ++)
{
	vnt = F[| f];
		
	//Add the vertex to the model buffer
	v = V[| vnt[0]];
	if !is_array(v){v = [0, 0, 0];}
	buffer_write(mbuff, buffer_f32, v[0]);
	buffer_write(mbuff, buffer_f32, v[2]);
	buffer_write(mbuff, buffer_f32, v[1]);
		
	n = N[| vnt[1]];
	if !is_array(n){n = [0, 0, 1];}
	buffer_write(mbuff, buffer_f32, n[0]);
	buffer_write(mbuff, buffer_f32, n[2]);
	buffer_write(mbuff, buffer_f32, n[1]);
		
	t = T[| vnt[2]];
	if !is_array(t){t = [0, 0];}
	buffer_write(mbuff, buffer_f32, t[0]);
	buffer_write(mbuff, buffer_f32, 1-t[1]);
		
	buffer_write(mbuff, buffer_u8, 255);
	buffer_write(mbuff, buffer_u8, 255);
	buffer_write(mbuff, buffer_u8, 255);
	buffer_write(mbuff, buffer_u8, 255);
}
ds_list_destroy(F);
ds_list_destroy(V);
ds_list_destroy(N);
ds_list_destroy(T);
show_debug_message("Script spart___load_obj_to_buffer: Successfully loaded obj " + string(filename));

buffer_seek(mbuff, buffer_seek_start, 0);
return mbuff