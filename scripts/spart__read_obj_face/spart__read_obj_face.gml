/// @description spart__read_obj_face(faceList, str)
/// @param faceList
/// @param str
function spart__read_obj_face(argument0, argument1) {
    var i, j;
    var faceList = argument0;
    var str = argument1;
    str = string_delete(str, 1, string_pos(" ", str))
    if (string_char_at(str, string_length(str)) == " ")
    {
        //Make sure the string doesn't end with an empty space
        str = string_copy(str, 0, string_length(str) - 1);
    }
    var triNum = string_count(" ", str);
    var vertString = array_create(triNum + 1);
    for (i = 0; i < triNum; i ++)
    {
        //Add vertices in a triangle fan
        vertString[i] = string_copy(str, 1, string_pos(" ", str));
        str = string_delete(str, 1, string_pos(" ", str));
    }
    vertString[i--] = str;
    while i--
    {
        for (j = 2; j >= 0; j --)
        {
            ds_list_add(faceList, spart__read_obj_vertstring(vertString[(i + j) * (j > 0)]));
        }
    }


}
