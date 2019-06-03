/// @description void momu_open(MenuElement);
/// @param MenuElement

var catch=argument0;

menu_activate(noone);

// don't do it right here because you may do things with tileset surfaces and that makes
// bad things happen if you're in the middle of drawing
Camera.schedule_open=true;
