/// @description spart__read_obj_vertstring(str)
/// @param str
function spart__read_obj_vertstring(argument0) {
    var vertString = argument0;
    var v = 0, n = 0, t = 0;
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
    if n < 0{n = -n;}
    if t < 0{t = -t;}
    return [v-1, n-1, t-1];


}
