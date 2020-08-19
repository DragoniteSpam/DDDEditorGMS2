function colour_replace_blue(original, value) {
	return (value << 16) | (original & 0x00ffff);
}

function colour_replace_green(original, value) {
	return (value << 8) | (original & 0xff00ff);
}

function colour_replace_red(original, value) {
	return value | (original & 0xffff00);
}

function colour_reverse(color) {
	// because game maker colors are bgr, and when it's displayed it's usually
    // rgb it doesn't actually matter if the color is already bgr or rgb,
    // because reversing either will be correct anyway
	return ((color & 0xff0000) >> 16) | (color & 0x00ff00) | ((color & 0x0000ff) << 16);
}

function merge_colour_ds(c1, c2, f) {
	// this seems to be slightly different from merge_colour and i dont know why?
	// also it can do alpha
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