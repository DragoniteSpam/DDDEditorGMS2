/// @description d3d - set projection 
/// @param xFrom	x of from position
/// @param yFrom	y of from position
/// @param zFrom	z of from position
/// @param xTo		x of to position
/// @param yTo		y of to position
/// @param zTo		z of to position
/// @param xUp		x of up vector
/// @param yUp		y of up vector
/// @param zUp		z of up vector
/// @param fov		field of view angle
/// @param aspect	aspect ration
/// @param zmin		z buffer min
/// @param zmax		z buffer max

var mV = matrix_build_lookat( argument0, argument1, argument2, 
							 argument3, argument4, argument5,
							 argument6, argument7, argument8 );
var mP = matrix_build_projection_perspective_fov( -argument9, -argument10, argument11, argument12 );

camera_set_view_mat( camera_get_active(), mV );
camera_set_proj_mat( camera_get_active(), mP );
camera_apply( camera_get_active() );
