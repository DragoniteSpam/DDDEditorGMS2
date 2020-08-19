/// @description stdf_load_obj_to_buffer(fname)
/// @param fname
function stdf_load_obj_to_buffer(argument0) {
    /*
    Loads an .obj model into a buffer
    */
    var vBuff, filename, n_index, t_index, v_index, file, i, j, str, type, vertString, triNum, temp_faces, modelArray;
    filename = argument0;
    file = file_text_open_read(filename);
    if file == -1{show_debug_message("Failed to load model " + string(filename)); return -1;}
    show_debug_message("Script spart__load_obj: Loading obj file " + string(filename));

    //Create the necessary lists
    var vx, vy, vz, nx, ny, nz, tx, ty, fl, v, n, t, f;
    vx = ds_list_create(); vx[| 0] = 0;
    vy = ds_list_create(); vy[| 0] = 0;
    vz = ds_list_create(); vz[| 0] = 0;
    nx = ds_list_create(); nx[| 0] = 0;
    ny = ds_list_create(); ny[| 0] = 0;
    nz = ds_list_create(); nz[| 0] = 0;
    tx = ds_list_create(); tx[| 0] = 0;
    ty = ds_list_create(); ty[| 0] = 0;
    fl = ds_list_create();

    //Read .obj as textfile
    while !file_text_eof(file)
    {
        str = string_replace_all(file_text_read_string(file),"  "," ");
        type = string_copy(str, 1, 2);
        str = string_delete(str, 1, string_pos(" ", str));
        //Different types of information in the .obj starts with different headers
        switch type
        {
            //Load vertex positions
            case "v ":
                ds_list_add(vx, real(string_copy(str, 1, string_pos(" ", str))));
                str = string_delete(str, 1, string_pos(" ", str));     
                ds_list_add(vy, real(string_copy(str, 1, string_pos(" ", str))));  
                ds_list_add(vz, real(string_delete(str, 1, string_pos(" ", str))));
                break;
            //Load vertex normals
            case "vn":
                ds_list_add(nx, real(string_copy(str, 1, string_pos(" ", str))));
                str = string_delete(str, 1, string_pos(" ", str)); 
                ds_list_add(ny, real(string_copy(str, 1, string_pos(" ", str))));
                ds_list_add(nz, real(string_delete(str, 1, string_pos(" ", str))));
                break;
            //Load vertex texture coordinates
            case "vt":
                ds_list_add(tx, real(string_copy(str, 1, string_pos(" ", str))));
                ds_list_add(ty, real(string_delete(str, 1, string_pos(" ", str))));
                break;
            //Load faces
            case "f ":
                if (string_char_at(str, string_length(str)) == " "){str = string_copy(str, 0, string_length(str) - 1);}
                triNum = string_count(" ", str);
                for (i = 0; i < triNum; i ++){
                    vertString[i] = string_copy(str, 1, string_pos(" ", str));
                    str = string_delete(str, 1, string_pos(" ", str));}
                vertString[i--] = str;
                while i--{for (j = 2; j >= 0; j --){
                    ds_list_add(fl, vertString[(i + j) * (j > 0)]);}}
                break;
            }
        file_text_readln(file);
    }
    file_text_close(file);

    //Loop through the loaded information and generate a model
    var vertCol = c_white;
    var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
    var mbuff = buffer_create(ds_list_size(fl) * bytesPerVert, buffer_fixed, 1);
    for (var f = 0; f < ds_list_size(fl); f ++)
    {
        vertString = ds_list_find_value(fl, f);
        v = 0; n = 0; t = 0;
        //If the vertex contains a position, texture coordinate and normal
        if string_count("/", vertString) == 2 and string_count("//", vertString) == 0{
            v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
            vertString = string_delete(vertString, 1, string_pos("/", vertString));
            t = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
            n = real(string_delete(vertString, 1, string_pos("/", vertString)));}
        //If the vertex contains a position and a texture coordinate
        else if string_count("/", vertString) == 1{
            v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
            t = real(string_delete(vertString, 1, string_pos("/", vertString)));}
        //If the vertex only contains a position
        else if (string_count("/", vertString) == 0){
            v = real(vertString);}
        //If the vertex contains a position and normal
        else if string_count("//", vertString) == 1{
            vertString = string_replace(vertString, "//", "/");
            v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
            n = real(string_delete(vertString, 1, string_pos("/", vertString)));}
        if v < 0{v = -v;}
        if t < 0{t = -t;}
        if n < 0{n = -n;}
            
        //Add the vertex to the model buffer
        buffer_write(mbuff, buffer_f32, vx[| v]);
        buffer_write(mbuff, buffer_f32, vz[| v]);
        buffer_write(mbuff, buffer_f32, vy[| v]);
    
        buffer_write(mbuff, buffer_f32, nx[| n]);
        buffer_write(mbuff, buffer_f32, nz[| n]);
        buffer_write(mbuff, buffer_f32, ny[| n]);
    
        buffer_write(mbuff, buffer_f32, tx[| t]);
        buffer_write(mbuff, buffer_f32, 1-ty[| t]);
    
        buffer_write(mbuff, buffer_u8, 255);
        buffer_write(mbuff, buffer_u8, 255);
        buffer_write(mbuff, buffer_u8, 255);
        buffer_write(mbuff, buffer_u8, 255);
    }
    ds_list_destroy(fl);
    ds_list_destroy(vx);
    ds_list_destroy(vy);
    ds_list_destroy(vz);
    ds_list_destroy(nx);
    ds_list_destroy(ny);
    ds_list_destroy(nz);
    ds_list_destroy(tx);
    ds_list_destroy(ty);
    show_debug_message("Script spart__load_obj: Successfully loaded obj " + string(filename));

    return mbuff;


}
