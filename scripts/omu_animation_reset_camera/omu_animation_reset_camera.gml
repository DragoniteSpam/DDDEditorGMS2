/// @param UIThing
function omu_animation_reset_camera(argument0) {

	var thing = argument0;

	Stuff.animation.x = 0;
	Stuff.animation.y = 160;
	Stuff.animation.z = 80;

	Stuff.animation.xto = 0;
	Stuff.animation.yto = 0;
	Stuff.animation.zto = 0;

	Stuff.animation.xup = 0;
	Stuff.animation.yup = 0;
	Stuff.animation.zup = 1;

	Stuff.animation.fov = 50;
	Stuff.animation.pitch = 0;
	Stuff.animation.direction = 0;


}
