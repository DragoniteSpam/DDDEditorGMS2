/// @description smf_camera_set_projmat(camera, FOV, aspect, near, far)
/// @param camera
/// @param FOV
/// @param aspect
/// @param near
/// @param far
function smf_camera_set_projmat(argument0, argument1, argument2, argument3, argument4) {
	/*
	Creates a camera for the given view
	If view is -1, the camera is not assigned to any views. This is useful for for example shadow maps.

	Script created by TheSnidr
	www.thesnidr.com
	*/
	var camera = argument0;
	var camSettings = SMF_cameras[? camera];

	camSettings[| SMF_cam.FOV] = argument1;
	camSettings[| SMF_cam.aspect] = argument2;
	camSettings[| SMF_cam.near] = argument3;
	camSettings[| SMF_cam.far] = argument4;
	camSettings[| SMF_cam.pmat] = matrix_build_projection_perspective_fov(-camSettings[| SMF_cam.FOV], -camSettings[| SMF_cam.aspect], camSettings[| SMF_cam.near], camSettings[| SMF_cam.far]);
	camera_set_proj_mat(camera, camSettings[| SMF_cam.pmat]);


}
