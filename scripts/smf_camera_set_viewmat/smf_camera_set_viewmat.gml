/// @description smf_cam_set_view_mat(camera, xFrom, yFrom, zFrom, xTarget, yTarget, zTarget, xup, yup, zup)
/// @param camera
/// @param x
/// @param y
/// @param z
/// @param xTo
/// @param yTo
/// @param zTo
/// @param xUp
/// @param yUp
/// @param zUp
function smf_camera_set_viewmat(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9) {
    var camera = argument0;
    var camSettings = SMF_cameras[? camera];

    camSettings[| SMF_cam.vmat] = matrix_build_lookat(argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9);
    camera_set_view_mat(camera, camSettings[| SMF_cam.vmat]);


}
