/// @param c1
/// @param c2
/// @param f
function merge_colour_ds(argument0, argument1, argument2) {

	// this seems to be slightly different from merge_colour and i dont know why?
	// also it can do alpha

	var c1 = argument0;
	var c2 = argument1;
	var f = argument2;

	var rr1 = (c1 & 0x000000ff);
	var gg1 = (c1 & 0x0000ff00) >> 8;
	var bb1 = (c1 & 0x00ff0000) >> 16;
	var aa1 = (c1 & 0xff000000) >> 24;
	var rr2 = (c2 & 0x000000ff);
	var gg2 = (c2 & 0x0000ff00) >> 8;
	var bb2 = (c2 & 0x00ff0000) >> 16;
	var aa2 = (c2 & 0xff000000) >> 24;

	return lerp(rr1, rr2, f) | (lerp(gg1, gg2, f) << 8) | (lerp(bb1, bb2, f) << 16) | lerp(aa1, aa2, f) << 24;


}
