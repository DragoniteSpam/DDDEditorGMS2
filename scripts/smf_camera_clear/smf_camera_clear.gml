/// @description smf_camera_clear()
function smf_camera_clear() {
	//Deletes all cameras
	var cam = ds_map_find_first(SMF_cameras);
	repeat ds_map_size(SMF_cameras)
	{
	    camera_destroy(cam);
	    ds_list_destroy(SMF_cameras[? cam]);
	    cam = ds_map_find_next(SMF_cameras, cam);
	}
	ds_map_clear(SMF_cameras);


}
