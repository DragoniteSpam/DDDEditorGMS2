/// @description smf_cam_init(view, FOV, aspect, near, far)
/// @param view_index
/// @param FOV
/// @param aspect
/// @param near
/// @param far
/*
Creates a camera for the given view
If view is -1, the camera is not assigned to any views. This is useful for for example shadow maps.

Script created by TheSnidr
www.thesnidr.com
*/
var camera = camera_create();
var camSettings = ds_list_create();
SMF_cameras[? camera] = camSettings;

camSettings[| SMF_cam.view] = argument0;
camSettings[| SMF_cam.FOV] = argument1;
camSettings[| SMF_cam.aspect] = argument2;
camSettings[| SMF_cam.near] = argument3;
camSettings[| SMF_cam.far] = argument4;
camSettings[| SMF_cam.vmat] = matrix_build_identity();
camSettings[| SMF_cam.pmat] = matrix_build_projection_perspective_fov(-camSettings[| SMF_cam.FOV], -camSettings[| SMF_cam.aspect], camSettings[| SMF_cam.near], camSettings[| SMF_cam.far]);
camSettings[| SMF_cam.vpmat] = matrix_build_identity();

camera_set_proj_mat(camera, camSettings[| SMF_cam.pmat]);

if camSettings[| SMF_cam.view] >= 0
{
    view_enabled = true;
    view_set_visible(camSettings[| SMF_cam.view], true);
    view_set_camera(camSettings[| SMF_cam.view], camera);
}

return camera;