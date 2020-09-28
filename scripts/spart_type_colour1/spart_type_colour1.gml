/// @description spart_type_colour1(partType, colour1, alpha1)
/// @param partType
/// @param colour1
/// @param alpha1
function spart_type_colour1() {
    /*
        Sets the particle colour to the given colour and alpha

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partType, col, colArray, i = 0, j = 0;
    partType = argument[j++];
    partType[| sPartTyp.ColourType] = 1;
    colArray = partType[| sPartTyp.Colour];
    col = argument[j++];
    colArray[@ i++] = color_get_red(col)/255;
    colArray[@ i++] = color_get_green(col)/255;
    colArray[@ i++] = color_get_blue(col)/255;
    colArray[@ i++] = argument[j++];


}
