function smf_3d_disable() {
	//Turns off the z-buffer
	gpu_set_zwriteenable(false);
	gpu_set_ztestenable(false);
	gpu_set_cullmode(cull_noculling);


}
