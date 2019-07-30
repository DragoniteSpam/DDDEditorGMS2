/// @param color
// because game maker colors are bgr, and when it's displayed it's usually rgb
// it doesn't actually matter if the color is already bgr or rgb, because reversing
// either will be correct anyway

return ((argument0 & 0xff0000) >> 16) | (argument0 & 0x00ff00) | ((argument0 & 0x0000ff) << 16);