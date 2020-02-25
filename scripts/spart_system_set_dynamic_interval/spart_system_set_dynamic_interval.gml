/// @description spart_system_set_dynamic_interval(partSystem, interval)
/// @param partSystem
/// @param interval
/*
	Set the interval for how often dynamic emitters may create new retired emitters.
	This is useful for controlling the performance hit.
	
	Higher interval means fewer new emitters and fewer draw calls, at the cost of movement artifacts.
	
	Script created by TheSnidr
	www.TheSnidr.com
*/
var partSys = argument0;
partSys[| sPartSys.DynamicInterval] = argument1;