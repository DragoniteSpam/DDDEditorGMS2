/// @description spart_type_colour3(partType, colour1, alpha1, colour2, alpha2, colour3, alpha3)
/// @param partType
/// @param colour1
/// @param alpha1
/// @param colour2
/// @param alpha2
/// @param colour3
/// @param alpha3
function spart_type_colour3() {
	/*
		Sets the particle colour to a smooth gradient between the three given
		colours depending on the particle's life span

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType, col, colArray, i = 0, j = 0;
	partType = argument[j++];
	partType[| sPartTyp.ColourType] = 3;
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
	col = argument[j++];
	colArray[@ i++] = color_get_red(col)/255;
	colArray[@ i++] = color_get_green(col)/255;
	colArray[@ i++] = color_get_blue(col)/255;
	colArray[@ i++] = argument[j++];



}
