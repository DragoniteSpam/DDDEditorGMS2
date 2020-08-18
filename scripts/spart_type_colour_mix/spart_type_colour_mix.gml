/// @description spart_type_colour_mix(partType, colour1, alpha1, colour2, alpha2)
/// @param partType
/// @param colour1
/// @param alpha1
/// @param colour2
/// @param alpha2
function spart_type_colour_mix() {
	/*
		Sets the colour of the particle to a random mix between the two given colours

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType, col, colArray, i = 0, j = 0;
	partType = argument[j++];
	partType[| sPartTyp.ColourType] = 0;
	colArray = partType[| sPartTyp.Colour];
	col = argument[j++];
	colArray[@ i++] = color_get_red(col)/255;
	colArray[@ i++] = color_get_green(col)/255;
	colArray[@ i++] = color_get_blue(col)/255;
	colArray[@ i++] = argument[j++];
	col = argument[j++];
	colArray[@ i++] = color_get_red(col)/255;
	colArray[@ i++] = color_get_green(col)/255;
	colArray[@ i++] = color_get_blue(col)/255;
	colArray[@ i++] = argument[j++];


}
