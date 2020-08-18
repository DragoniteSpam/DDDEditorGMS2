/// @param EditorModeAnimation
function editor_save_setting_animation(argument0) {

	var animation = argument0;

	setting_set("Animation", "x", animation.x);
	setting_set("Animation", "y", animation.y);
	setting_set("Animation", "z", animation.z);
	setting_set("Animation", "xto", animation.xto);
	setting_set("Animation", "yto", animation.yto);
	setting_set("Animation", "zto", animation.zto);
	setting_set("Animation", "fov", animation.fov);


}
